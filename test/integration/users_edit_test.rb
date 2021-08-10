require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:kevin)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path( @user )
    assert_template 'users/edit'
    patch user_path(@user), params: {user: { name: "",
                                             email: "bad@email",
                                             password: "foo",
                                             password_confirmation: "bar" }}
    assert_template "users/edit"
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_user_path( @user )
    assert_template 'users/edit'
    name = "TESTER"
    email = "TESTER@EXAMPLE.COM"
    patch user_path(@user), params: { user: { 
                                              name:                  "TESTER",
                                              email:                 "TESTER@EXAMPLE.COM",
                                              password:              "",
                                              password_confirmation: "" }}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email.downcase, @user.email
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path( @user )
    assert_not_nil session[:forwarding_url]
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "TESTER"
    email = "TESTER@EXAMPLE.COM"
    patch user_path(@user), params: { user: { 
                                              name:                  "TESTER",
                                              email:                 "TESTER@EXAMPLE.COM",
                                              password:              "",
                                              password_confirmation: "" }}
    assert_not flash.empty?
    assert_redirected_to @user
    assert_nil session[:forwarding_url]
    @user.reload
    assert_equal name, @user.name
    assert_equal email.downcase, @user.email
  end

end
