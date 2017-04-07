class IdpInitForm
  include ActiveModel::Model

  attr_reader :use_exact_comparison_type, :public_cert_file, :service_url, :entity_id
  validates :use_exact_comparison_type, :public_cert_file, :service_url, :entity_id, presence: true
  validates :service_url, format: { with: /:\/\// }
  validates :public_cert_file, certificate: true

  def initialize(hash)
    @entity_id = hash[:entity_id]
    @service_url = hash[:service_url]
    @public_cert_file = hash[:public_cert_file]
    @use_exact_comparison_type = hash[:use_exact_comparison_type]
  end

  def params
    {
      'idpEntityId' => entity_id,
      'singleSignOnServiceUrl' => service_url,
      'idpPublicCert' => public_certificate,
      'useExactComparisonTypeInSamlAuthnRequest' => use_exact_comparison_type == '1'
    }
  end

  def public_certificate
    @public_cert_file
      .read
      .encode('UTF-8')
      .sub(/-+BEGIN CERTIFICATE-+([^-]*)-+END CERTIFICATE-+/m, '\\1')
      .gsub(/\s+/, '')
  end
end
