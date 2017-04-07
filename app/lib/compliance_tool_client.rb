require 'uri'
require 'net/http'
require 'json'

class ComplianceToolClient
  URL = ENV.fetch('COMPLIANCE_TOOL_URL', 'https://compliance-tool-reference.ida.digital.cabinet-office.gov.uk')

  def self.get_request(location)
    url = URI(location)
    request = Net::HTTP::Get.new(url.path)
    Rails.logger.debug("ComplianceToolClient GET: #{url}")
    http(url).request(request)
  end

  def self.post_request(path, data)
    url = URI("#{URL}/#{path}")
    request = Net::HTTP::Post.new(url.path, 'Content-Type' => 'application/json')
    request.body = data.to_json
    Rails.logger.debug("ComplianceToolClient POST: #{url}\n#{data}")
    http(url).request(request)
  end

  def self.http(url)
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    http
  end
end