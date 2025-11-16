require "test_helper"

module HttpClients
  class BaseClientTest < ActiveSupport::TestCase
    def setup
      @client = BaseClient.new
    end

    test "get_response returns parsed JSON" do
      stub_request(:get, "http://www.example.com").to_return(
        status: 200,
        body: { "key" => "value" }.to_json
      )

      assert_equal({ "key" => "value" }, @client.get_response("http://www.example.com"))
    end

    test "get_response for non-successful response raises ApiError" do
      stub_request(:get, "http://www.example.com").to_return(
        status: 500
      )

      assert_raises BaseClient::ApiError do
        @client.get_response("http://www.example.com")
      end
    end

    test "get_response for invalid JSON raises ApiError" do
      stub_request(:get, "http://www.example.com").to_return(
        status: 200,
        body: "invalid json"
      )

      assert_raises BaseClient::ApiError do
        @client.get_response("http://www.example.com")
      end
    end

    test "get_response for network error raises ApiError" do
      stub_request(:get, "http://www.example.com").to_raise(StandardError)

      assert_raises BaseClient::ApiError do
        @client.get_response("http://www.example.com")
      end
    end
  end
end
