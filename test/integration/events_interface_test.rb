require 'test_helper'

class EventsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @event = @user.events_as_host.first
    @user_two = users(:two)
  end

  test "event interface" do
    log_in_as(@user)
    get new_event_path
    assert_template "events/new"

    # Create invalid event.
    assert_no_difference "Event.count" do
      post events_path, event: { name: "", description: "", event_date: nil }
    end
    assert_template "events/new"
    assert_select 'div#error_explanation'

    # Create valid event.
    name = "Ex"
    description = "Lorem ipsum."
    assert_difference "Event.count", 1 do
      post_via_redirect events_path, event: { name: name,
                                              description: description,
                                              event_date: Time.now }
    end
    assert_template "events/show"
    assert_not flash.empty?

    # Delete an event.
    get user_path(@user)
    assert_select 'a', text: 'delete'
    assert_difference "Event.count", -1 do
      delete event_path(@event)
    end
    # Goes to root_url rather than user_path(@user) because this is a test.
    assert_redirected_to root_url
    follow_redirect!
    assert_not flash.empty?

    # Visit a different user.
    get user_path(@user_two)
    assert_select 'a', text: 'delete', count: 0
  end
end
