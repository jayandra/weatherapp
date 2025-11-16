class WeatherForecaster
  WeatherForecast = Struct.new(:current_temp, :today_max_temp, :today_min_temp, :forecast_temps)

  def initialize(client)
    @client = client || HttpClients::OpenmeteoForecastClient.new
  end

  # Get weather forecast for a given location
  # returns WeatherForecast struct or empty hash if error
  def perform(latitude:, longitude:, timezone:)
    response = @client.forecast(latitude: latitude, longitude: longitude, timezone: timezone)
    WeatherForecast.new(
      current_temp: response[:current_temp],
      today_max_temp: response[:today_max_temp],
      today_min_temp: response[:today_min_temp],
      forecast_temps: response[:forecast_max_temps].zip(response[:forecast_min_temps])
    )
  rescue HttpClients::BaseClient::ApiError
    {}
  end
end
