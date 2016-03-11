require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = users(:one)
  end

  test "should get index" do
    log_in_as(@user)
    get :index
    assert_response :success
    assert_select "title", full_title("Users")
  end

  test "should redirect index when not logged in" do
    get :index
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should get show" do
    log_in_as(@user)
    get :show, id: @user.id
    assert_response :success
    assert_select "title", full_title(@user.name)
  end

  test "should redirect show when not logged in" do
    get :show, id: @user.id
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_select "title", full_title("Sign up")
  end

  test "should post create" do
    post :create, user: { name: "Ex", email: "ex@example.com",
                          password: "foobar", password_confirmation: "foobar" }
    assert_response :redirect
  end
end
