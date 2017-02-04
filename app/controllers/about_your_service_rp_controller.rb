class AboutYourServiceRpController < ApplicationController
  def initialize
    @id_form = RpIdForm.new({})
    @matching_form = RpMatchingForm.new({})
    @certificates_form = RpCertificatesForm.new({})
  end

  def about_your_service_rp_id
    render 'about_your_service/rp/id', :layout => 'application'
  end

  def about_your_service_rp_id_post
    @id_form = RpIdForm.new(params.fetch('rp_id_form', {}))

    if @id_form.valid?
      cookies['rp_entity_id'] = @id_form.entity_id
      cookies['rp_service_url'] = @id_form.service_url

      redirect_to '/about-your-service/rp/matching'
    else
      render 'about_your_service/rp/id', :layout => 'application'
    end
  end

  def about_your_service_rp_matching
    render 'about_your_service/rp/matching', :layout => 'application'
  end

  def about_your_service_rp_matching_post
    @matching_form = RpMatchingForm.new(params.fetch('rp_matching_form', {}))

    cookies['rp_expected_pid'] = @matching_form.expected_pid
    cookies['rp_matching_service_entity_id'] = @matching_form.ms_entity_id
    cookies['rp_matching_service_keystore'] = @matching_form.ms_keystore

    redirect_to '/about-your-service/rp/certificates'
  end

  def about_your_service_rp_certificates
    render 'about_your_service/rp/certificates', :layout => 'application'
  end

  def about_your_service_rp_certificates_post
    @certificates_form = RpCertificatesForm.new(params.fetch('rp_certificates_form', {}))

    cookies['rp_signing_cert'] = @certificates_form.signing_cert
    cookies['rp_encryption_cert'] = @certificates_form.encryption_cert

    redirect_to '/confirm/rp'
  end
end
