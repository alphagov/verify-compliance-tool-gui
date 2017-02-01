class AboutYourServiceRpController < ApplicationController
  def about_your_service_rp_id
    render 'about_your_service/rp/id', :layout => 'application'
  end

  def about_your_service_rp_id_post
    entity_id = params.fetch('entity-id')
    service_url = params.fetch('url')

    cookies['rp_entity_id'] = entity_id
    cookies['rp_service_url'] = service_url

    redirect_to '/about-your-service/rp/matching'
  end

  def about_your_service_rp_matching
    render 'about_your_service/rp/matching', :layout => 'application'
  end

  def about_your_service_rp_matching_post
    expected_pid = params.fetch('expected-pid')
    matching_service_entity_id = params.fetch('ms-entity-id')
    matching_service_private_key = params.fetch('ms-private-key')

    cookies['rp_expected_pid'] = expected_pid
    cookies['rp_matching_service_entity_id'] = matching_service_entity_id
    cookies['rp_matching_service_private_key'] = matching_service_private_key

    redirect_to '/about-your-service/rp/certificates'
  end

  def about_your_service_rp_certificates
    render 'about_your_service/rp/certificates', :layout => 'application'
  end

  def about_your_service_rp_certificates_post
    signing_cert = params.fetch('signing-cert')
    encryption_cert = params.fetch('encryption-cert')

    cookies['rp_signing_cert'] = signing_cert
    cookies['rp_encryption_cert'] = encryption_cert

    redirect_to '/confirm/rp'
  end
end
