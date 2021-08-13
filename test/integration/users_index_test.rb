require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin     = users(:kevin)
    @non_admin = users(:ariel)
    @per_page  = 10
  end

  test "index as admin including pagination and delete/activate links" do
    log_in_as(@admin)
    first_page_of_users = User.paginate( page: 1, per_page: @per_page )
    first_page_of_users.first.toggle!(:activated)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    assigns(:users).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
        assert_select 'a[href=?]', manual_activate_toggle_user_path(user)
      end
    end
    put manual_activate_toggle_user_path(first_page_of_users.first)
    get users_path
    assert_select 'p', text: 'NOT ACTIVATED', count: 1
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
    assert_select 'a', text: 'deactivate', count: 0
    assert_select 'a', text: 'activate', count: 0
    assert @non_admin.activated?
    put manual_activate_toggle_user_path(@non_admin)
    assert_response :redirect
    assert @non_admin.reload.activated?
  end

end
