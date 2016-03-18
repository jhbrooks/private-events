require 'test_helper'

class InvitesNewTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @event = @user.events_as_host.first
    @user_two = users(:two)
    @user_three = users(:three)
  end

  test "valid new and create with multiple invites" do
    log_in_as(@user)
    get new_event_invite_path(@event)
    assert_template "invites/new"
    assert_difference "Invite.count", 2 do
      post_via_redirect new_event_invite_path(@event),
                        user_ids: { "#{@user.id}" => "0",
                                    "#{@user_two.id}" => "1",
                                    "#{@user_three.id}" => "1" }
    end
    assert_template "events/show"
    assert_not flash.empty?
  end
end
