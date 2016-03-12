require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @different_user = users(:two)
  end

  test "user profile with links to hosted events and total count" do
    log_in_as(@user)
    get user_path(@user)
    assert_template "users/show"
    assert_select "title", full_title(@user.name)
    assert_select "h1", text: @user.name
    assert_match formatted_date(@user.created_at, "Member since "),
                 response.body
    assert_select "a[href=?]", new_event_path, text: "Create new event"
    assert_match @user.events_as_host.count.to_s, response.body
    @user.events_as_host.each do |event|
      assert_select "a[href=?]", event_path(event), text: event.name
      assert_match formatted_date(event.event_date, "Begins on "),
                                  response.body
    end
  end

  test "different user profile lacking create new event link" do
    log_in_as(@user)
    get user_path(@different_user)
    assert_template "users/show"
    assert_select "title", full_title(@different_user.name)
    assert_select "h1", text: @different_user.name
    assert_match formatted_date(@different_user.created_at, "Member since "),
                 response.body
    assert_select "a[href=?]", new_event_path, text: "Create new event",
                                               count: 0
  end
end
