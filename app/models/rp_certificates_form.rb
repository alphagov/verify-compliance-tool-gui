require 'openssl'

class RpCertificatesForm
  include ActiveModel::Model

  attr_reader :signing_cert_file, :encryption_cert_file
  validates :signing_cert_file, :encryption_cert_file, presence: true
  validates :signing_cert_file, :encryption_cert_file, certificate: true

  def initialize(hash) 
    @signing_cert_file = hash[:signing_cert_file]
    @encryption_cert_file = hash[:encryption_cert_file]
  end

  def signing_certificate
    oneline_cert(@signing_cert_file)
  end

  def encryption_certificate
    oneline_cert(@encryption_cert_file)
  end

  private

  def oneline_cert(cert_file)
    cert_file
      .read
      .encode('UTF-8')
      .sub(/-+BEGIN CERTIFICATE-+([^-]*)-+END CERTIFICATE-+/m, '\\1')
      .gsub(/\s+/, '')
  end
end
