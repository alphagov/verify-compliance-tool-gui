require 'rails_helper'

describe IdpInitForm do
  it 'should accept good inputs' do
    params = {
      entity_id: 'an-entity-id',
      service_url: 'http://example.com',
      public_cert_file: StringIO.new(good_cert),
      use_exact_comparison_type: '0'
    }
    form = IdpInitForm.new(params)
    expect(form.valid?).to eql(true)
  end

  it 'should reject an invalid service URL' do
    params = {
      entity_id: 'an-entity-id',
      service_url: 'http:/example.com',
      public_cert_file: StringIO.new(good_cert),
      use_exact_comparison_type: '0'
    }
    form = IdpInitForm.new(params)
    expect(form.valid?).to eql(false)
    expect(form.errors.include?(:service_url)).to eql(true)
  end

  it 'should reject an invalid cert file' do
    params = {
      entity_id: 'an-entity-id',
      service_url: 'http://example.com',
      public_cert_file: StringIO.new(bad_cert),
      use_exact_comparison_type: '0'
    }
    form = IdpInitForm.new(params)
    expect(form.valid?).to be(false)
    expect(form.errors.include?(:public_cert_file)).to eql(true)
    expect(form.errors[:public_cert_file].first).to eql('is not an X509 certificate in PEM format')
  end

  it 'should create a valid IDP test run JSON message' do
    json = {
      'idpEntityId' => 'an-entity-id',
      'singleSignOnServiceUrl' => 'http://example.com',
      'idpPublicCert' => oneline_cert,
      'useExactComparisonTypeInSamlAuthnRequest' => false
    }
    params = {
      entity_id: 'an-entity-id',
      service_url: 'http://example.com',
      public_cert_file: StringIO.new(good_cert),
      use_exact_comparison_type: '0'
    }
    form = IdpInitForm.new(params)
    expect(form.params).to eql(json)
  end
end
