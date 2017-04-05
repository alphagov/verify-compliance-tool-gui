class RpController < ApplicationController
  def initialize
    @init_form = RpIdForm.new({})
    @matching_form = RpMatchingForm.new({})
    @certificates_form = RpCertificatesForm.new({})
  end

  def rp_id
    render 'rp/id', :layout => 'application'
  end

  def rp_id_post
    @init_form = RpIdForm.new(params.fetch('rp_id_form', {}))

    if @init_form.valid?
      cookies['rp_entity_id'] = @init_form.entity_id
      cookies['rp_service_url'] = @init_form.service_url

      redirect_to rp_matching_path
    else
      render 'rp/id', :layout => 'application'
    end
  end

  def rp_matching
    render 'rp/matching', :layout => 'application'
  end

  def rp_matching_post
    @matching_form = RpMatchingForm.new(params.fetch('rp_matching_form', {}))

    if @matching_form.valid?
      cookies['rp_expected_pid'] = @matching_form.expected_pid
      cookies['rp_matching_service_entity_id'] = @matching_form.ms_entity_id
      cookies['rp_matching_service_keystore'] = RpMatchingForm::normalize_keystore(@matching_form.ms_keystore)
      redirect_to '/about-your-service/rp/certificates'
    else
      render 'rp/matching', :layout => 'application'
    end
  end

  def rp_certificates
    render 'rp/certificates', :layout => 'application'
  end

  def rp_certificates_post
    @certificates_form = RpCertificatesForm.new(params.fetch('rp_certificates_form', {}))

    if @certificates_form.valid?
      cookies['rp_signing_cert'] = RpCertificatesForm::normalize_certificate(@certificates_form.signing_cert)
      cookies['rp_encryption_cert'] = RpCertificatesForm::normalize_certificate(@certificates_form.encryption_cert)
      redirect_to '/confirm/rp'
    else
      render 'rp/certificates', :layout => 'application'
    end

  end

end
