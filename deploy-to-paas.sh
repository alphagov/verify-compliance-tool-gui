#!/bin/bash

set -eu
set -o pipefail

cd "$(dirname "$0")"
BASEDIR=$(pwd)
BUILD_NUMBER=${BUILD_NUMBER:?"BUILD_NUMBER environment variable needs to be set"} >&2

cfLogin() {
  if [ -z "${CF_USER:-}" ]; then
    echo "Using cached credentials in ${CF_HOME:-home directory}" >&2
  else
    CF_API="${CF_API:?CF_USER is set - CF_API environment variable also needs to be set}"
    CF_ORG="${CF_ORG:?CF_USER is set - CF_ORG environment variable also needs to be set}"
    CF_SPACE="${CF_SPACE:?CF_USER is set - CF_SPACE environment variable also needs to be set}"
    CF_PASS="${CF_PASS:?CF_USER is set - CF_PASS environment variable also needs to be set}"

    # CloudFoundry will cache credentials in ~/.cf/config.json by default.
    # Create a dedicated work area to avoid contaminating the user's credential cache
    export CF_HOME="$BASEDIR"/work
    rm -rf "$CF_HOME"
    mkdir -p "$CF_HOME"

    echo "Authenticating to CloudFoundry at '$CF_API' ($CF_ORG/$CF_SPACE) as '$CF_USER'" >&2
    cf api "$CF_API"
    # Like 'cf login' but for noninteractive use
    cf auth "$CF_USER" "$CF_PASS"
    cf target -o "$CF_ORG" -s "$CF_SPACE"

    # More secure (but maybe less reliable) way:
    # cf login -a "$CF_API" -u "$CF_USER" <<<"$CF_PASS"
  fi
}

deploy() {
  local APP_NAME_BASE="verify-compliance-tool-ui"
  local APP_NAME="${APP_NAME_BASE}-${BUILD_NUMBER}"
  local CF_DOMAIN="cloudapps.digital"

  echo "Deploying:     $APP_NAME"

  cf push "$APP_NAME" -f manifest.yml -n "$APP_NAME"
  cf map-route "$APP_NAME" "$CF_DOMAIN" -n "$APP_NAME_BASE"

  DEPLOYEDAPPS=$(cf apps | awk -v "app=$APP_NAME" '$1 ~ app {print $1}')

  for APP in $DEPLOYEDAPPS; do
    if [ "$APP" != "$APP_NAME" ]; then
      echo "Removing old/orphaned deployment of ${APP_NAME_BASE}: $APP" >&2
      # TODO: Check to see if a route exists before nuking it so that
      #       we can detect unexpected failures of 'cf unmap-route'
      cf unmap-route "$APP" "$CF_DOMAIN" -n "$ROUTE_NAME" || :
      cf delete -r -f "$APP"
    fi
  done

  echo "New route:     ${APP_NAME}.${CF_DOMAIN}"
}

cfLogin
deploy
cf logout || :
