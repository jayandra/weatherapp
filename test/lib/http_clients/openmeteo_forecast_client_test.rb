require "test_helper"

module HttpClients
  class OpenmeteoForecastClientTest < ActiveSupport::TestCase
    def setup
      @client = HttpClients::OpenmeteoForecastClient.new
    end

    test "forecast with valid params returns forecast for the city" do
      stub_request(:get, "https://api.open-meteo.com/v1/forecast").
        with(query: {
          daily: "temperature_2m_max,temperature_2m_min",
          current: "temperature_2m",
          forecast_days: Geocoder::DEFAULT_COUNT + 1,
          temperature_unit: "fahrenheit",
          latitude: 32.97485,
          longitude: -97.3478,
          timezone: "America/Chicago"
        }).
        to_return(
          status: 200,
          body: {
            "latitude": 32.974926,
            "longitude": -97.34612,
            "generationtime_ms": 0.05364418029785156,
            "utc_offset_seconds": -21600,
            "timezone": "America/Chicago",
            "timezone_abbreviation": "GMT-6",
            "elevation": 215.0,
            "current_units": {
                "time": "iso8601",
                "interval": "seconds",
                "temperature_2m": "°F"
            },
            "current": {
                "time": "2025-11-16T00:30",
                "interval": 900,
                "temperature_2m": 69.7
            },
            "daily_units": {
                "time": "iso8601",
                "temperature_2m_max": "°F",
                "temperature_2m_min": "°F"
            },
            "daily": {
                "time": [
                    "2025-11-16",
                    "2025-11-17",
                    "2025-11-18",
                    "2025-11-19",
                    "2025-11-20",
                    "2025-11-21"
                ],
                "temperature_2m_max": [
                    81.9,
                    86.2,
                    84.8,
                    78.9,
                    75.6,
                    71.5
                ],
                "temperature_2m_min": [
                    58.5,
                    59.6,
                    68.2,
                    67.8,
                    61.2,
                    57.0
                ]
            }
          }.to_json
        )

      assert_equal @client.forecast(latitude: 32.97485, longitude: -97.3478, timezone: "America/Chicago"), {
        current_temp: 69.7,
        today_max_temp: 81.9,
        today_min_temp: 58.5,
        forecast_days: [ "2025-11-17", "2025-11-18", "2025-11-19", "2025-11-20", "2025-11-21" ],
        forecast_max_temps: [ 86.2, 84.8, 78.9, 75.6, 71.5 ],
        forecast_min_temps: [ 59.6, 68.2, 67.8, 61.2, 57.0 ]
      }
    end

    test "forecast with invalid params raises error" do
      stub_request(:get, "https://api.open-meteo.com/v1/forecast").
        with(query: {
          daily: "temperature_2m_max,temperature_2m_min",
          current: "temperature_2m",
          forecast_days: Geocoder::DEFAULT_COUNT + 1,
          temperature_unit: "fahrenheit",
          latitude: 32.97485,
          longitude: -97.3478,
          timezone: "America/Chicago"
        }).
        to_return(status: 404, body: {
          "error": true,
          "reason": "Not Found"
        }.to_json)

      assert_raises BaseClient::ApiError do
        @client.forecast(latitude: 32.97485, longitude: -97.3478, timezone: "America/Chicago")
      end
    end
  end
end
