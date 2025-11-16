require "application_system_test_case"

class SearchesTest < ApplicationSystemTestCase
  setup do
    @search = searches(:one)
  end

  # test "should create search" do
  #   visit searches_url
  #   click_on "New search"

  #   fill_in "City", with: @search.city
  #   click_on "Create Search"

  #   assert_text "Search was successfully created"
  #   click_on "Back"
  # end
end
