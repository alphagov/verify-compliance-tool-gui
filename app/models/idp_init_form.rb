class IdpInitForm
  include ActiveModel::Model

  attr_reader :use_exact_comparison_type, :public_certificate, :service_url, :entity_id
  validates :use_exact_comparison_type, :public_certificate, :service_url, :entity_id, presence: true
  validates :service_url, format: { with: /:\/\// }
  validates :public_certificate, certificate: true

  def initialize(hash)
    @entity_id = hash[:entity_id]
    @service_url = hash[:service_url]
    @public_certificate = hash[:public_certificate]
    @use_exact_comparison_type = hash[:use_exact_comparison_type]
  end

  def params
    public_cert_as_string = public_certificate.read
                            .encode('UTF-8')
                            .sub(/-+BEGIN CERTIFICATE-+([^-]*)-+END CERTIFICATE-+/m, '\\1')
                            .gsub(/\s+/, '')

    {
      'idpEntityId' => entity_id,
      'singleSignOnServiceUrl' => service_url,
      'idpPublicCert' => public_cert_as_string,
      'useExactComparisonTypeInSamlAuthnRequest' => use_exact_comparison_type == '1',
    }
  end
end
