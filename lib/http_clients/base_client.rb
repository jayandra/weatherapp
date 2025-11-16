require "net/http"
require "uri"
require "json"

# This is the base HTTP client that all other client's inherit
# Add future HTTP calls (POST, DELETE, etc.) to this class for reusability in other clients
module HttpClients
  class BaseClient
    class ApiError < StandardError; end

    # Generic HTTP GET request
    def get_response(url, params = {})
      uri = URI(url)
      uri.query = URI.encode_www_form(params)

      response = Net::HTTP.get_response(uri)
      raise ApiError, "Api request failed with status #{response.code}" unless response.is_a?(Net::HTTPSuccess)

      JSON.parse(response.body)

    rescue JSON::ParserError => e
      raise ApiError, "Failed to parse JSON response #{e.message}"
    rescue StandardError => e
      raise ApiError, "HTTP request failed with error #{e.message}"
    end
  end
end
