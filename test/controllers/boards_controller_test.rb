require "test_helper"

class BoardsControllerTest < ActionDispatch::IntegrationTest
  test "should get display" do
    get boards_display_url
    assert_response :success
  end
end
