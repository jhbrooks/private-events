require 'test_helper'

class InviteTest < ActiveSupport::TestCase
  def setup
    @invite = invites(:one)
  end

  test "should be valid" do
    assert @invite.valid?
  end

  test "user_id should be present" do
    @invite.user_id = nil
    assert_not @invite.valid?
  end

  test "event_id should be present" do
    @invite.event_id = nil
    assert_not @invite.valid?
  end
end
