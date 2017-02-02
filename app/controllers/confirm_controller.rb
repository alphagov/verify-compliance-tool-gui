require 'uri'
require 'net/http'
require 'json'

class ConfirmController < ApplicationController
  def confirm_rp
    render 'confirm/confirm'
  end

  def confirm_rp_post
    compliance_tool_url = URI('https://compliance-tool-reference.ida.digital.cabinet-office.gov.uk/rp-test-data')
    compliance_tool_settings = {
      rpEntityId:  cookies.fetch('rp_entity_id'),
      assertionConsumerServiceUrl:  cookies.fetch('rp_service_url'),
      signingPublicCert: cookies.fetch('rp_signing_cert'),
      encryptionPublicCert: cookies.fetch('rp_encryption_cert'),
      expectedPID: cookies.fetch('rp_expected_pid'),
      matchingServiceEntityId: cookies.fetch('rp_matching_service_entity_id'),
      matchingServiceSigningPrivateCert: cookies.fetch('rp_matching_service_private_key'),
    }

    compliance_tool_request = Net::HTTP::Post.new(compliance_tool_url.path, 'Content-Type' => 'application/json')
    compliance_tool_request.body = compliance_tool_settings.to_json
    compliance_tool_response = Net::HTTP.start(compliance_tool_url.hostname, compliance_tool_url.port, use_ssl: compliance_tool_url.scheme == 'https') { |http| http.request(compliance_tool_request) }

    if compliance_tool_response.code == '200'
      redirect_to '/success/rp'
    else
      flash[:error] = compliance_tool_response.body
      redirect_to '/error'
    end
  end
end
