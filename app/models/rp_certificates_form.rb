class RpCertificatesForm
  include ActiveModel::Model

  attr_reader :signing_cert, :encryption_cert

  def initialize(hash) 
    @signing_cert = hash[:signing_cert]
    @encryption_cert = hash[:encryption_cert]
  end
  
end

