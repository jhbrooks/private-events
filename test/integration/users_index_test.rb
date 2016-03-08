require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test "index with pagination" do
    get users_path
    assert_template "users/index"
    assert_select "div.pagination"
    assert_select "a[href=?]", user_path(@user), text: @user.name
    User.offset(1).paginate(page: 1).each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
    end
  end
end
