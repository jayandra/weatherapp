require "test_helper"

module HttpClients
  class OpenmeteoGeocodeClientTest < ActiveSupport::TestCase
    def setup
      @client = HttpClients::OpenmeteoGeocodeClient.new
    end

    test "searching a city prefix returns top 5 results containing name, country, latitude, longitude, admin1, admin2" do
      stub_request(:get, "https://geocoding-api.open-meteo.com/v1/search?name=hasle&count=5").to_return(
        status: 200,
        body: {
          "results": [
              {
                  "id": 2660410,
                  "name": "Hasle",
                  "latitude": 46.97787,
                  "longitude": 8.05326,
                  "elevation": 752.0,
                  "feature_code": "PPL",
                  "country_code": "CH",
                  "admin1_id": 2659810,
                  "admin2_id": 8740968,
                  "admin3_id": 7286032,
                  "timezone": "Europe/Zurich",
                  "population": 1725,
                  "postcodes": [
                      "6166"
                  ],
                  "country_id": 2658434,
                  "country": "Switzerland",
                  "admin1": "Lucerne",
                  "admin2": "Entlebuch District",
                  "admin3": "Hasle (LU)"
              },
              {
                  "id": 2620716,
                  "name": "Hasle",
                  "latitude": 55.18212,
                  "longitude": 14.71117,
                  "elevation": 22.0,
                  "feature_code": "PPL",
                  "country_code": "DK",
                  "admin1_id": 6418538,
                  "admin2_id": 2623665,
                  "timezone": "Europe/Copenhagen",
                  "population": 1634,
                  "postcodes": [
                      "3790"
                  ],
                  "country_id": 2623032,
                  "country": "Denmark",
                  "admin1": "Capital Region",
                  "admin2": "Bornholm Kommune"
              },
              {
                  "id": 2660409,
                  "name": "Hasle",
                  "latitude": 47.01436,
                  "longitude": 7.65112,
                  "elevation": 589.0,
                  "feature_code": "PPL",
                  "country_code": "CH",
                  "admin1_id": 2661551,
                  "admin2_id": 8260133,
                  "admin3_id": 7286031,
                  "timezone": "Europe/Zurich",
                  "postcodes": [
                      "3415"
                  ],
                  "country_id": 2658434,
                  "country": "Switzerland",
                  "admin1": "Bern",
                  "admin2": "Emmental District",
                  "admin3": "Hasle bei Burgdorf"
              },
              {
                  "id": 2620715,
                  "name": "Hasle",
                  "latitude": 56.16863,
                  "longitude": 10.16178,
                  "elevation": 72.0,
                  "feature_code": "PPL",
                  "country_code": "DK",
                  "admin1_id": 6418539,
                  "admin2_id": 2624647,
                  "timezone": "Europe/Copenhagen",
                  "country_id": 2623032,
                  "country": "Denmark",
                  "admin1": "Central Jutland",
                  "admin2": "Aarhus Kommune"
              },
              {
                  "id": 2909508,
                  "name": "Häsle",
                  "latitude": 48.98333,
                  "longitude": 10.06667,
                  "elevation": 466.0,
                  "feature_code": "PPL",
                  "country_code": "DE",
                  "admin1_id": 2953481,
                  "admin2_id": 3214105,
                  "admin3_id": 2856827,
                  "admin4_id": 6558025,
                  "timezone": "Europe/Berlin",
                  "country_id": 2921044,
                  "country": "Germany",
                  "admin1": "Baden-Wurttemberg",
                  "admin2": "Regierungsbezirk Stuttgart",
                  "admin3": "Ostalbkreis",
                  "admin4": "Ellwangen (Jagst)"
              }
          ],
          "generationtime_ms": 0.6285906
        }.to_json
      )

      assert_equal @client.search(name: "hasle", count: 5).length, 5
      assert_equal @client.search(name: "hasle", count: 5)[0], { name: "Hasle", country: "Switzerland", latitude: 46.97787, longitude: 8.05326, timezone: "Europe/Zurich", admin1: "Lucerne", admin2: "Entlebuch District" }
    end

    test "search with garbage prefix raises NoGeocodingResultsError" do
      stub_request(:get, "https://geocoding-api.open-meteo.com/v1/search?name=zzzaa&count=5").to_return(
        status: 200,
        body: {
          "generationtime_ms": 0.56266785
        }.to_json
      )

      assert_raises HttpClients::OpenmeteoGeocodeClient::NoGeocodingResultsError do
        @client.search(name: "zzzaa", count: 5)
      end
    end
  end
end
