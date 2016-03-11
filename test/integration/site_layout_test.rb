require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test "site layout when logged out" do
    get root_path
    assert_select "title", full_title
    assert_template "static_pages/home"
    assert_select "a[href=?]", root_path, count: 1
    assert_select "a[href=?]", users_path, text: "Users", count: 0
    assert_select "a[href=?]", login_path, text: "Log in", count: 1
    assert_select "a[href=?]", logout_path, text: "Log out", count: 0
    assert_select "a[href=?]", signup_path, text: "Sign up now!", count: 1
    assert_select "a[href=?]", user_path(@user), text: "Profile", count: 0

    get login_path
    assert_select "title", full_title("Log in")
    assert_template "sessions/new"
    assert_select "a[href=?]", root_path, count: 1
    assert_select "a[href=?]", users_path, text: "Users", count: 0
    assert_select "a[href=?]", login_path, text: "Log in", count: 1
    assert_select "a[href=?]", logout_path, text: "Log out", count: 0
    assert_select "a[href=?]", user_path(@user), text: "Profile", count: 0

    get signup_path
    assert_select "title", full_title("Sign up")
    assert_template "users/new"
    assert_select "a[href=?]", root_path, count: 1
    assert_select "a[href=?]", users_path, text: "Users", count: 0
    assert_select "a[href=?]", login_path, text: "Log in", count: 1
    assert_select "a[href=?]", logout_path, text: "Log out", count: 0
    assert_select "a[href=?]", user_path(@user), text: "Profile", count: 0
  end

  test "site layout when logged in" do
    log_in_as(@user)
    get root_path
    assert_select "title", full_title
    assert_template "static_pages/home"
    assert_select "a[href=?]", root_path, count: 1
    assert_select "a[href=?]", users_path, text: "Users", count: 1
    assert_select "a[href=?]", login_path, text: "Log in", count: 0
    assert_select "a[href=?]", logout_path, text: "Log out", count: 1
    assert_select "a[href=?]", user_path(@user), text: "Profile", count: 1
    assert_select "a[href=?]", user_path(@user), text: "View profile", count: 1

    get users_path
    assert_select "title", full_title("Users")
    assert_template "users/index"
    assert_select "a[href=?]", root_path, count: 1
    assert_select "a[href=?]", users_path, text: "Users", count: 1
    assert_select "a[href=?]", login_path, text: "Log in", count: 0
    assert_select "a[href=?]", logout_path, text: "Log out", count: 1
    assert_select "a[href=?]", user_path(@user), text: "Profile", count: 1
  end
end
