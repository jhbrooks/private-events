require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "site layout" do
    get root_path
    assert_select "title", full_title
    assert_template "static_pages/home"
    assert_select "a[href=?]", root_path, count: 1
    assert_select "a[href=?]", users_path, text: "Users", count: 1
    assert_select "a[href=?]", "#", text: "Log in", count: 1
    assert_select "a[href=?]", signup_path, text: "Sign up now!", count: 1
  end
end
