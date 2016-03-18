require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @different_user = users(:two)
  end

  test "user profile with links to events and total counts" do
    log_in_as(@user)
    get user_path(@user)
    assert_template "users/show"
    assert_select "title", full_title(@user.name)
    assert_select "h1", text: @user.name
    assert_match "Member for ", response.body
    assert_select "a[href=?]", new_event_path, text: "Create new event"

    # Hosted events
    assert_match @user.events_as_host.count.to_s, response.body
    @user.events_as_host.each do |event|
      assert_select "a[href=?]", event_path(event), text: event.name
      assert_match formatted_date(event.event_date, "Begins on "),
                                  response.body
    end

    # Attending events
    attending_events = @user.events_as_guest.where('invites.reply' => 'yes')
    assert_match attending_events.count.to_s, response.body
    attending_events.each do |event|
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
    assert_match "Member for ", response.body
    assert_select "a[href=?]", new_event_path, text: "Create new event",
                                               count: 0
  end
end
