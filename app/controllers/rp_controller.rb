class RpController < ApplicationController
  def rp_id
    @init_form = RpIdForm.new({})
    render rp_id_path
  end

  def rp_id_post
    @init_form = RpIdForm.new(params.fetch('rp_id_form', {}))

    if @init_form.valid?
      cookies['rp_entity_id'] = @init_form.entity_id
      cookies['rp_service_url'] = @init_form.service_url

      redirect_to rp_matching_path
    else
      render rp_id_path
    end
  end

  def rp_matching
    @matching_form = RpMatchingForm.new({})
    render rp_matching_path
  end

  def rp_matching_post
    @matching_form = RpMatchingForm.new(params.fetch('rp_matching_form', {}))

    if @matching_form.valid?
      cookies['rp_expected_pid'] = @matching_form.expected_pid
      cookies['rp_matching_service_entity_id'] = @matching_form.ms_entity_id
      cookies['rp_matching_service_keystore'] = @matching_form.ms_keystore
      redirect_to rp_certificates_path
    else
      render rp_matching_path
    end
  end

  def rp_certificates
    @certificates_form = RpCertificatesForm.new({})
    render rp_certificates_path
  end

  def rp_certificates_post
    @certificates_form = RpCertificatesForm.new(params.fetch('rp_certificates_form', {}))

    if @certificates_form.valid?
      cookies['rp_signing_cert'] = @certificates_form.signing_certificate
      cookies['rp_encryption_cert'] = @certificates_form.encryption_certificate
      redirect_to rp_confirm_path
    else
      render rp_certificates_path
    end
  end

  def confirm
    render rp_confirm_path
  end

  def confirm_post
    params = {
      'rpEntityId' => cookies.fetch('rp_entity_id'),
      'assertionConsumerServiceUrl' => cookies.fetch('rp_service_url'),
      'signingPublicCert' => cookies.fetch('rp_signing_cert'),
      'encryptionPublicCert' => cookies.fetch('rp_encryption_cert'),
      'expectedPID' => cookies.fetch('rp_expected_pid'),
      'matchingServiceEntityId' => cookies.fetch('rp_matching_service_entity_id'),
      'matchingServiceSigningPrivateCert' => cookies.fetch('rp_matching_service_keystore'),
    }

    rsp = ComplianceToolClient.post_request('rp-test-data', params)

    if rsp.code == '200'
      redirect_to rp_success_path
    else
      flash[:error] = rsp.body
      redirect_to error_path
    end
  end

  def success
    render rp_success_path
  end
end
