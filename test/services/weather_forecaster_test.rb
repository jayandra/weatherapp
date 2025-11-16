require "test_helper"

class WeatherForecasterTest < ActiveSupport::TestCase
  def setup
    @client = mock("openmeteo_forecast_client")
    @service = WeatherForecaster.new(@client)
  end

  test "calling perform with proper attributes returns the weather forecast" do
    @client.expects(:forecast).
    with(latitude: 32.97485, longitude: -97.3478, timezone: "America/Chicago").
    returns({
      current_temp: 62.9,
      today_max_temp: 77.7,
      today_min_temp: 58.5,
      forecast_days: [ "2025-11-17", "2025-11-18", "2025-11-19", "2025-11-20", "2025-11-21" ],
      forecast_max_temps: [ 86.4, 87.9, 80.9, 73.7, 72.9 ],
      forecast_min_temps: [ 61.1, 67.2, 67.6, 62.5, 58.4 ]
    })

    result = @service.perform(latitude: 32.97485, longitude: -97.3478, timezone: "America/Chicago")
    assert_equal 62.9, result.current_temp
    assert_equal 77.7, result.today_max_temp
    assert_equal 58.5, result.today_min_temp
    assert_equal [
      [ "2025-11-17", 86.4, 61.1 ],
      [ "2025-11-18", 87.9, 67.2 ],
      [ "2025-11-19", 80.9, 67.6 ],
      [ "2025-11-20", 73.7, 62.5 ],
      [ "2025-11-21", 72.9, 58.4 ]
    ], result.forecast_temps
  end

  test "calling perform with invalid attributes returns {}" do
    @client.expects(:forecast).
    with(latitude: 32.97485, longitude: -97.3478, timezone: "America/Chicago").
    raises(HttpClients::BaseClient::ApiError)

    result = @service.perform(latitude: 32.97485, longitude: -97.3478, timezone: "America/Chicago")
    assert_equal ({}), result
  end
end
