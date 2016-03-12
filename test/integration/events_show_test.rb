require 'test_helper'

class EventsShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @event = events(:one)
    @non_hosted_event = events(:two)
  end

  test "show event page" do
    log_in_as(@user)
    get event_path(@event)
    assert_template "events/show"
    assert_select "title", full_title(@event.name)
    assert_select "h1", text: @event.name
    assert_match @event.description, response.body
    assert_match formatted_date(@event.event_date, "Begins on "),
                 response.body
    assert_select "a", text: "delete"

    assert_difference "Event.count", -1 do
      delete event_path(@event)
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_template "static_pages/home"

    get event_path(@non_hosted_event)
    assert_template "events/show"
    assert_select "title", full_title(@non_hosted_event.name)
    assert_select "h1", text: @non_hosted_event.name
    assert_match @non_hosted_event.description, response.body
    assert_match formatted_date(@event.event_date, "Begins on "),
                 response.body
    assert_select "a", text: "delete", count: 0
  end
end
