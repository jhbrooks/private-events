require 'test_helper'

class InvitesEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @invite = invites(:one)
  end

  test "valid edit and update" do
    log_in_as(@user)
    get edit_user_invite_path(@user, @invite)
    assert_template "invites/edit"
    patch user_invite_path(@user, @invite), invite: { reply: "test" }
    @invite.reload
    assert_equal "test", @invite.reply
  end
end
