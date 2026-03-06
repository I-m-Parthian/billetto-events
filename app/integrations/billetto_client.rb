require "uri"
require "net/http"
require "json"

class BillettoClient
  BASE_URL = "https://billetto.dk/api/v3".freeze
  DEFAULT_HEADERS = {
    "Accept" => "application/json"
  }.freeze
  DEFAULT_LIMIT = 10
  OPEN_TIMEOUT = 5
  READ_TIMEOUT = 10

  def initialize
    @keypair = ENV.fetch("BILLETTO_KEYPAIR")
  end

  def fetch_public_events(limit: DEFAULT_LIMIT)
    get("/public/events", limit: limit)
  end

  private

  def get(path, params = {})
    uri = URI("#{BASE_URL}#{path}")
    uri.query = URI.encode_www_form(params) if params.any?
    request = Net::HTTP::Get.new(uri, DEFAULT_HEADERS.merge("Api-Keypair" => @keypair))
    response = Net::HTTP.start(
      uri.host,
      uri.port,
      use_ssl: true,
      open_timeout: OPEN_TIMEOUT,
      read_timeout: READ_TIMEOUT
    ) do |http|
      http.request(request)
    end

    handle_response(response)
  end

  def handle_response(response)
    unless response.is_a?(Net::HTTPSuccess)
      raise "Billetto API Error: #{response.code} #{response.message}"
    end

    JSON.parse(response.body)
  end
end
