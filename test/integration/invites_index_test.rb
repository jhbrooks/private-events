require 'test_helper'

class InvitesIndexTest < ActionDispatch::IntegrationTest
  def setup
    @guest_user = users(:one)
  end

  test "invites index" do
    log_in_as(@guest_user)
    get user_invites_path(@guest_user)
    assert_template "invites/index"
    @guest_user.invites.each do |invite|
      assert_select "a[href=?]", event_path(invite.event),
                                 text: invite.event.name
      assert_select "a[href=?]", user_path(invite.event.host),
                                 text: invite.event.host.name
      assert_match "Current reply: ", response.body
      assert_select "a[href=?]", edit_user_invite_path(@guest_user, invite),
                                 text: "change reply"
      assert_select "a[href=?]", invite_path(invite), text: "delete"
    end
  end
end
