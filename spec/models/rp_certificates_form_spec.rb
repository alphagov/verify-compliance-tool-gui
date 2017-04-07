require 'rails_helper'

describe RpCertificatesForm do
  it 'should accept good inputs' do
    params = {
      signing_cert_file: StringIO.new(good_cert),
      encryption_cert_file: StringIO.new(good_cert),
    }
    form = RpCertificatesForm.new(params)
    expect(form.valid?).to eql(true)
  end

  it 'should reject an invalid cert file' do
    params = {
      signing_cert_file: StringIO.new(good_cert),
      encryption_cert_file: StringIO.new(bad_cert),
    }
    form = RpCertificatesForm.new(params)
    expect(form.valid?).to be(false)
    expect(form.errors.include?(:encryption_cert_file)).to eql(true)
    expect(form.errors[:encryption_cert_file].first).to eql('is not an X509 certificate in PEM format')
  end
end