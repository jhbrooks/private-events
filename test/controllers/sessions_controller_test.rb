require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  def setup
    @user = users(:one)
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_select "title", full_title("Log in")
  end

  test "should post create" do
    post :create, session: { email: @user.email, password: "password" }
    assert_response :redirect
  end

  test "should delete destroy" do
    delete :destroy
    assert_response :redirect
  end
end
