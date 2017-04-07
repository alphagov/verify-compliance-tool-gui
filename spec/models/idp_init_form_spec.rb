require 'rails_helper'

describe IdpInitForm do
  let(:good_cert) {
    <<~ENDCERT
      -----BEGIN CERTIFICATE-----
      MIIETDCCAzSgAwIBAgIQRwSIhqCSmQCuChRw71CwfjANBgkqhkiG9w0BAQsFADBL
      MQswCQYDVQQGEwJHQjEXMBUGA1UEChMOQ2FiaW5ldCBPZmZpY2UxDDAKBgNVBAsT
      A0dEUzEVMBMGA1UEAxMMSURBUCBUZXN0IENBMB4XDTE2MTIxMzAwMDAwMFoXDTE3
      MTIxMzIzNTk1OVowgYIxCzAJBgNVBAYTAkdCMQ8wDQYDVQQIEwZMb25kb24xDzAN
      BgNVBAcTBkxvbmRvbjEXMBUGA1UEChQOQ2FiaW5ldCBPZmZpY2UxDDAKBgNVBAsU
      A0dEUzEqMCgGA1UEAxMhU3R1YiBJRFAgU2lnbmluZyAoMjAxNjEyMTMxMjAwMjgp
      MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApqvRlSkula3cv81xUSGK
      laGq8q+EVkGgKcK6hkqX5ry5Y6TiDlLSqzO9ceDB+Ezdt35xnUEpvzit3ajEc7IX
      wmY+RYE/h5LrnD8MczUO8U9uJMWYvTdFZw5lFin0gj/tXPEIwDa/jolt24t/m7z7
      Gfl2Zd1YkqU/56yDjGl5WENHwezyt0OZ93+Pde6XjZ/2LEwUatO2SI6nSUKyeKRM
      nRq9UKZP3vEtuc/FTfmVsTb0H5M0N9SIv4Y6b93Vv8r3KwggkUec72ioZ8iPAjso
      MJscQrzjZHRbqTdcuVSHF9/BbRdSR8N9R+vrW86U+mwZ8Hi5zeIj61axMpCma6I+
      FQIDAQABo4HzMIHwMAwGA1UdEwEB/wQCMAAwVQYDVR0fBE4wTDBKoEigRoZEaHR0
      cDovL29uc2l0ZWNybC50cnVzdHdpc2UuY29tL0NhYmluZXRPZmZpY2VJREFQVGVz
      dENBL0xhdGVzdENSTC5jcmwwDgYDVR0PAQH/BAQDAgeAMB0GA1UdDgQWBBRW3sAY
      GbvRqmfkX8xLpaYWBhH8mjAfBgNVHSMEGDAWgBRqEU1kUN/eY29XoYgf+AOVDiIE
      tDA5BggrBgEFBQcBAQQtMCswKQYIKwYBBQUHMAGGHWh0dHA6Ly9zdGQtb2NzcC50
      cnVzdHdpc2UuY29tMA0GCSqGSIb3DQEBCwUAA4IBAQAQbvMPHKkRO0DRXJBZlmZg
      D9mheE5WRPbiy1ZfZLqFw+j+zXsofawxz1VpO1AkT0Hfvq2FotcnuUiCel+xRWtF
      G86blJIlzLXUhdokHXCQqT9nvgc2WM3O3rh7mOKVq3Y8hOwdpCaBNpI5i0zIYrK9
      nIZaV2XD8Jqb+vW/z9QMNVxUBqvpoPr+y1fVOa9wy8RO3p5yEWpGRLIpwuU6oJAf
      bjroEpn8LsXR0SFKv7KBvtn/bfts9KLpRQ1XLXnjUh/RQmO8sHBDg1vq191I9dkU
      OFRwr9+eEDJNPhbuzwdkndSqKz7xMz4/8F+yR5q3ylBn0lVP/MIkEA9x0bUJHSWT
      -----END CERTIFICATE-----
    ENDCERT
  }

  let(:bad_cert) { 'I am a bad, bad little certificate' }

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
      'idpPublicCert' => 'MIIETDCCAzSgAwIBAgIQRwSIhqCSmQCuChRw71CwfjANBgkqhkiG9w0BAQsFADBLMQswCQYDVQQGEwJHQjEXMBUGA1UEChMOQ2FiaW5ldCBPZmZpY2UxDDAKBgNVBAsTA0dEUzEVMBMGA1UEAxMMSURBUCBUZXN0IENBMB4XDTE2MTIxMzAwMDAwMFoXDTE3MTIxMzIzNTk1OVowgYIxCzAJBgNVBAYTAkdCMQ8wDQYDVQQIEwZMb25kb24xDzANBgNVBAcTBkxvbmRvbjEXMBUGA1UEChQOQ2FiaW5ldCBPZmZpY2UxDDAKBgNVBAsUA0dEUzEqMCgGA1UEAxMhU3R1YiBJRFAgU2lnbmluZyAoMjAxNjEyMTMxMjAwMjgpMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApqvRlSkula3cv81xUSGKlaGq8q+EVkGgKcK6hkqX5ry5Y6TiDlLSqzO9ceDB+Ezdt35xnUEpvzit3ajEc7IXwmY+RYE/h5LrnD8MczUO8U9uJMWYvTdFZw5lFin0gj/tXPEIwDa/jolt24t/m7z7Gfl2Zd1YkqU/56yDjGl5WENHwezyt0OZ93+Pde6XjZ/2LEwUatO2SI6nSUKyeKRMnRq9UKZP3vEtuc/FTfmVsTb0H5M0N9SIv4Y6b93Vv8r3KwggkUec72ioZ8iPAjsoMJscQrzjZHRbqTdcuVSHF9/BbRdSR8N9R+vrW86U+mwZ8Hi5zeIj61axMpCma6I+FQIDAQABo4HzMIHwMAwGA1UdEwEB/wQCMAAwVQYDVR0fBE4wTDBKoEigRoZEaHR0cDovL29uc2l0ZWNybC50cnVzdHdpc2UuY29tL0NhYmluZXRPZmZpY2VJREFQVGVzdENBL0xhdGVzdENSTC5jcmwwDgYDVR0PAQH/BAQDAgeAMB0GA1UdDgQWBBRW3sAYGbvRqmfkX8xLpaYWBhH8mjAfBgNVHSMEGDAWgBRqEU1kUN/eY29XoYgf+AOVDiIEtDA5BggrBgEFBQcBAQQtMCswKQYIKwYBBQUHMAGGHWh0dHA6Ly9zdGQtb2NzcC50cnVzdHdpc2UuY29tMA0GCSqGSIb3DQEBCwUAA4IBAQAQbvMPHKkRO0DRXJBZlmZgD9mheE5WRPbiy1ZfZLqFw+j+zXsofawxz1VpO1AkT0Hfvq2FotcnuUiCel+xRWtFG86blJIlzLXUhdokHXCQqT9nvgc2WM3O3rh7mOKVq3Y8hOwdpCaBNpI5i0zIYrK9nIZaV2XD8Jqb+vW/z9QMNVxUBqvpoPr+y1fVOa9wy8RO3p5yEWpGRLIpwuU6oJAfbjroEpn8LsXR0SFKv7KBvtn/bfts9KLpRQ1XLXnjUh/RQmO8sHBDg1vq191I9dkUOFRwr9+eEDJNPhbuzwdkndSqKz7xMz4/8F+yR5q3ylBn0lVP/MIkEA9x0bUJHSWT',
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
