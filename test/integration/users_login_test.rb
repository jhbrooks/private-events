require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test "invalid login" do
    get login_path
    assert_template "sessions/new"
    log_in_as(@user, password: "foo")
    assert_template "sessions/new"
    assert_not flash.empty?
    assert_not is_test_user_logged_in?
  end

  test "valid login and logout" do
    get login_path
    assert_template "sessions/new"
    log_in_as(@user)
    assert_redirected_to @user
    assert is_test_user_logged_in?

    delete logout_path
    assert_not is_test_user_logged_in?
    assert_redirected_to root_url
  end

  test "friendly forwarding" do
    get users_path
    follow_redirect!
    assert_template "sessions/new"
    log_in_as(@user)
    follow_redirect!
    assert_template "users/index"
  end

  test "unstore friendly forwarding if the login is not immediate" do
    get users_path
    follow_redirect!
    assert_template "sessions/new"
    get root_url
    assert_template "static_pages/home"
    get login_path
    assert_template "sessions/new"
    log_in_as(@user)
    follow_redirect!
    assert_template "users/show"
  end
end
