require "test_helper"

class SearchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @search = searches(:one)
  end

  test "should get index" do
    get searches_url
    assert_response :success
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

    assert_redirected_to search_url(Search.last)
  end

  test "should show search" do
    get search_url(@search)
    assert_response :success
  end

  test "should get edit" do
    get edit_search_url(@search)
    assert_response :success
  end

  test "should update search" do
    patch search_url(@search), params: { search: { city: @search.city } }
    assert_redirected_to search_url(@search)
  end

  test "should destroy search" do
    assert_difference("Search.count", -1) do
      delete search_url(@search)
    end

    assert_redirected_to searches_url
  end
end
