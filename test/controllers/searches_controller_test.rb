require "test_helper"

class SearchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @search = searches(:one)
  end

  test "should get new" do
    get new_search_url
    assert_response :success
  end

  test "should create search" do
    WeatherForecaster.any_instance.stubs(:perform).returns({
      current_temp: 69.7,
      today_max_temp: 81.9,
      today_min_temp: 58.5,
      forecast_temps: [
        [ "2025-11-17", 45.8, 30.8 ],
        [ "2025-11-18", 43.6, 38.8 ],
        [ "2025-11-19", 44.5, 41.0 ],
        [ "2025-11-20", 53.8, 42.7 ],
        [ "2025-11-21", 54.3, 43.7 ]
      ]
    })
    assert_difference("Search.count") do
      post searches_url, params: { search: { city: @search.city } }
    end

    assert_redirected_to new_search_url
  end
end
