require 'test_helper'

class ConvertersControllerTest < ActionDispatch::IntegrationTest

  test "should get index" do
    get static_pages_index_url
    assert_response :success
  end

end
