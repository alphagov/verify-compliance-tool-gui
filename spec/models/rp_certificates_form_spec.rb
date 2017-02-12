require 'rails_helper'

describe RpCertificatesForm do

  MALFORMED_CERT = <<-EOF
-----BEGIN CERTIFICATE-----
BANANA
-----END CERTIFICATE-----
EOF

  GOOD_CERT = <<-EOF
-----BEGIN CERTIFICATE-----
MIICvDCCAaQCCQDiHF/Fhzl3BTANBgkqhkiG9w0BAQsFADAgMR4wHAYDVQQDFBV0
ZXN0X21zYV9lbmNyeXB0aW9uXzEwHhcNMTcwMjAzMTcyOTUzWhcNMTcwMzA1MTcy
OTUzWjAgMR4wHAYDVQQDFBV0ZXN0X21zYV9lbmNyeXB0aW9uXzEwggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQCm9pfAowd8lzAvDzzeS2Y7XPtE8ofjbxB8
/c9Dnpg3mVPaL/ZiOVaSSGZnGHIZdSIyikICdD+52pZ4WYLVwldSKHzLfdEOgZWE
1FRd84SEDGWVCgTpeBCW7Gdo84Gf449zr/by9bzuFxBY8F6eC7qJQZq8q2Yf/gKi
JbbDsqpBpdloLnkS/HEyYHgI4auJEEGQxdhPXJ5FQdipvgP/MbS0me9k+bfYBFvV
IgxRb4Tkgskq+A/RUZXVkWfrH93LX+KbcRtudtjWrTM7bb1xR4jo5wbT5UTXDF/P
8P844aERSyiLQWDkq8XT4TJCxq3C8uSixnkTkTXd7zWcIWvkDmoZAgMBAAEwDQYJ
KoZIhvcNAQELBQADggEBAF64j02nUVj8sVz4zQSg6fQR3ySWF5RJvaecukm79LXr
9yhILXqo0Q87nPC9QNQTmLDUxPD3qV2sHIifcBm3FG//Dv+dJPsgvrgEqwKRmIMe
wk92W9J7G4MeeOzHkU4DUT8l5vm/rbt60sVKp1J8K+W20X5qURqdDTHzzbAJt1Ce
syQS3DuN/JxhTp3g3xPNe//XmQ7hbzrL1UBX1b/z7Oqilhvx3ZRp6hRuY/QKdn9I
8LgfN/rnWkfhOxkIjcqL3/fwdJGgHMcSpweWLsjabjstmZ0ZpxAHYM8kVuZY6aHG
WAgWh/LCQgDC+3z6SMSyiip7qi1qWWmx7C1NScqLvPQ=
-----END CERTIFICATE-----
EOF

  ONELINE_CERT = 'MIICvDCCAaQCCQDiHF/Fhzl3BTANBgkqhkiG9w0BAQsFADAgMR4wHAYDVQQDFBV0ZXN0X21zYV9lbmNyeXB0aW9uXzEwHhcNMTcwMjAzMTcyOTUzWhcNMTcwMzA1MTcyOTUzWjAgMR4wHAYDVQQDFBV0ZXN0X21zYV9lbmNyeXB0aW9uXzEwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCm9pfAowd8lzAvDzzeS2Y7XPtE8ofjbxB8/c9Dnpg3mVPaL/ZiOVaSSGZnGHIZdSIyikICdD+52pZ4WYLVwldSKHzLfdEOgZWE1FRd84SEDGWVCgTpeBCW7Gdo84Gf449zr/by9bzuFxBY8F6eC7qJQZq8q2Yf/gKiJbbDsqpBpdloLnkS/HEyYHgI4auJEEGQxdhPXJ5FQdipvgP/MbS0me9k+bfYBFvVIgxRb4Tkgskq+A/RUZXVkWfrH93LX+KbcRtudtjWrTM7bb1xR4jo5wbT5UTXDF/P8P844aERSyiLQWDkq8XT4TJCxq3C8uSixnkTkTXd7zWcIWvkDmoZAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAF64j02nUVj8sVz4zQSg6fQR3ySWF5RJvaecukm79LXr9yhILXqo0Q87nPC9QNQTmLDUxPD3qV2sHIifcBm3FG//Dv+dJPsgvrgEqwKRmIMewk92W9J7G4MeeOzHkU4DUT8l5vm/rbt60sVKp1J8K+W20X5qURqdDTHzzbAJt1CesyQS3DuN/JxhTp3g3xPNe//XmQ7hbzrL1UBX1b/z7Oqilhvx3ZRp6hRuY/QKdn9I8LgfN/rnWkfhOxkIjcqL3/fwdJGgHMcSpweWLsjabjstmZ0ZpxAHYM8kVuZY6aHGWAgWh/LCQgDC+3z6SMSyiip7qi1qWWmx7C1NScqLvPQ='

  it 'should say malformed certificate is not valid' do
    expect(RpCertificatesForm::certificate_is_valid MALFORMED_CERT).to eql false
  end

  it 'should say PEM formatted certificate is valid' do
    expect(RpCertificatesForm::certificate_is_valid GOOD_CERT).to eql true
  end

  it 'should say certificate without ASCII Armor is valid' do
    expect(RpCertificatesForm::certificate_is_valid ONELINE_CERT).to eql true
  end

  it 'should normalize a certificate' do
    expect(RpCertificatesForm::normalize_certificate GOOD_CERT).to eql ONELINE_CERT
  end

  it 'should format certificate without ASCII Armor' do
    expect(RpCertificatesForm::format_certificate ONELINE_CERT).to eql GOOD_CERT
  end
end