module HttpClients
  class OpenmeteoForecastClient
    BASE_URL = "https://api.open-meteo.com/v1/forecast"
    DEFAULT_PARAMS ={
      daily: "temperature_2m_max,temperature_2m_min",
      current: "temperature_2m",
      forecast_days: Geocoder::DEFAULT_COUNT + 1,
      temperature_unit: "fahrenheit"
    }

    def initialize
      @http_client = HttpClients::BaseClient.new
    end

    # Get forecast for a given location
    def forecast(latitude:, longitude:, timezone:)
      @response = @http_client.get_response(BASE_URL, DEFAULT_PARAMS.merge(latitude: latitude, longitude: longitude, timezone: timezone))
      format_response
    rescue BaseClient::ApiError => e
      Rails.logger.error("Forecast API error: #{e.message}")
      raise
    end

    private
    def format_response
      {
        current_temp: @response["current"]["temperature_2m"],
        today_max_temp: @response["daily"]["temperature_2m_max"][0],
        today_min_temp: @response["daily"]["temperature_2m_min"][0],
        forecast_max_temps: @response["daily"]["temperature_2m_max"][1..-1],
        forecast_min_temps: @response["daily"]["temperature_2m_min"][1..-1]
      }
    end
  end
end
