require "test_helper"

class GeocoderTest < ActiveSupport::TestCase
  def setup
    @mock_client = mock("openmeteo_geocoding_client")
    @service = Geocoder.new(@mock_client)
  end

  test "search returns an array of Geocode objects" do
    # Setup test data
    mock_response = [
      {
        "name" => "Haslet",
        "country" => "United States",
        "latitude" => 32.97485,
        "longitude" => -97.3478,
        "timezone" => "America/Chicago",
        "admin1" => "Texas",
        "admin2" => "Tarrant"
      }
    ]

    # Set expectations
    @mock_client.expects(:search)
                .with(name: "haslet", count: 5)
                .returns(mock_response)

    # Execute
    results = @service.perform("haslet")

    # Verify
    assert_equal 1, results.length

    result = results.first
    assert_instance_of Geocoder::Geocode, result
    assert_equal "Haslet", result.name
    assert_equal "United States", result.country
    assert_equal 32.97485, result.latitude
    assert_equal -97.3478, result.longitude
    assert_equal "America/Chicago", result.timezone
    assert_equal "Texas", result.admin1
    assert_equal "Tarrant", result.admin2
  end

  test "search with no results returns an empty array" do
    @mock_client.expects(:search).with(name: "zzzzaa", count: 5).raises(HttpClients::OpenmeteoGeocodeClient::NoGeocodingResultsError)
    assert_equal [], @service.perform("zzzzaa")
  end
end
