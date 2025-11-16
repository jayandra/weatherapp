class Geocoder
  Geocode = Struct.new(:name, :country, :latitude, :longitude, :timezone, :admin1, :admin2)
  DEFAULT_COUNT = 5

  # Initialize with an optional client to make it easy to swap out other geocoding service and ease testing
  def initialize(client = nil)
    @client = client || HttpClients::OpenmeteoGeocodeClient.new
  end

  # search for city prefix to return top 5 matches
  def perform(prefix)
    response = @client.search(name: prefix, count: DEFAULT_COUNT)
    response.map { |result| Geocode.new(**result) }
  rescue HttpClients::OpenmeteoGeocodeClient::NoGeocodingResultsError
    []
  end
end
