require 'openssl'

class RpCertificatesForm
  include ActiveModel::Model

  attr_reader :signing_cert, :encryption_cert
  validates :signing_cert, :encryption_cert, presence: true

  validates_each :signing_cert, :encryption_cert do |record, attr, input|
    record.errors.add(attr, 'Not a valid X509 certificate') unless certificate_is_valid input
  end

  def initialize(hash) 
    @signing_cert = hash[:signing_cert]
    @encryption_cert = hash[:encryption_cert]
  end

  def self.certificate_is_valid(input)
    normalized_input = normalize_certificate input
    formatted_input = format_certificate normalized_input
    if formatted_input.nil?
      return nil
    end
    begin
      OpenSSL::X509::Certificate.new formatted_input
      true
    rescue
      false
    end
  end

  def self.normalize_certificate(input)
    if input.nil?
      return nil
    end
    # Compliance tool expects PEM formatted X509 certs without (---BEGIN...) headers,
    # all squished onto one line. Not really fair to expect users to provide these, so
    # this method will normalize user input into this format, or return nil.
    input_no_headers_or_whitespace = input.sub(/-+BEGIN CERTIFICATE-+([^-]*)-+END CERTIFICATE-+/m, '\\1').gsub(/\s+/, '')
    # Only return the normalized result if it looks like a Base64 encoded PEM file:
    if input_no_headers_or_whitespace =~ /\AMII[A-Za-z0-9\/+=]+\Z/
      input_no_headers_or_whitespace
    else
      nil
    end
  end

  def self.format_certificate(input)
    if input.nil?
      return nil
    end
<<-EOF
-----BEGIN CERTIFICATE-----
#{input.gsub(/(.{1,62})/, "\\1\n").sub(/\n\Z/, '')}
-----END CERTIFICATE-----
EOF
  end
end
