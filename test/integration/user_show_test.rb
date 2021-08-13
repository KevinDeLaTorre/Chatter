require "test_helper"

class UserShowTest < ActionDispatch::IntegrationTest

  def setup
    @active     = users(:kevin)
    @inactive = users(:inactive)
  end

  test "should redirect user when inactive" do
    get user_path( @inactive )
    assert_response :redirect
    assert_redirected_to root_url
  end

  test "should display user when active" do
    get user_path(@active)
    assert_response :success
    assert_template 'users/show'
  end
end
