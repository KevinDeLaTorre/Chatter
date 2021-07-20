require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get signup_path
    assert_select "title", full_title( 'Sign up' )
    assert_response :success
  end
end
