require "test_helper"

class Api::V1::PostsControllerTest < ActionDispatch::IntegrationTest
  test "should get all_posts" do
    get api_v1_posts_all_posts_url
    assert_response :success
  end
end
