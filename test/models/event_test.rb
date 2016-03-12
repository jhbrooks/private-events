require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @event = @user.events_as_host.build(name: "Example Event",
                                        description: "Lorem ipsum.",
                                        event_date: Time.now)
  end

  test "should be valid" do
    assert @event.valid?
  end

  test "name should be present" do
    @event.name = "   "
    assert_not @event.valid?
  end

  test "description should be present" do
    @event.description = "   "
    assert_not @event.valid?
  end

  test "event_date should be present" do
    @event.event_date = nil
    assert_not @event.valid?
  end

  test "host_id should be present" do
    @event.host_id = nil
    assert_not @event.valid?
  end

  test "order should be greatest event_date first" do
    assert_equal events(:greatest_event_date), Event.first
  end
end
