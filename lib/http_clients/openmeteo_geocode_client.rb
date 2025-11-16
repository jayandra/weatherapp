require_relative "base_client"

# API client for open-metro geocoding API
# Returns an array of geocoding results for a given search query
module HttpClients
  class OpenmeteoGeocodeClient
    class NoGeocodingResultsError < StandardError; end

    BASE_URL = "https://geocoding-api.open-meteo.com/v1/search"

    def initialize
      @http_client ||= HttpClients::BaseClient.new
    end

    # Search for city prefix to return top N matches
    def search(name:, count:)
      @response = @http_client.get_response(BASE_URL, { name: name, count: count })
      format_results
    rescue BaseClient::ApiError => e
      Rails.logger.error("Geocoding API error: #{e.message}")
      raise
    end

    private

    def format_results
      results = @response["results"]
      raise NoGeocodingResultsError, "No geocoding results found" if results.nil?

      results.map do |result|
        {
          name: result["name"],
          country: result["country"],
          latitude: result["latitude"],
          longitude: result["longitude"],
          timezone: result["timezone"],
          admin1: result["admin1"],
          admin2: result["admin2"]
        }
      end
    end
  end
end
