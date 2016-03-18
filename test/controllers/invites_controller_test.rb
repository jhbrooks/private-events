require 'test_helper'

class InvitesControllerTest < ActionController::TestCase
  def setup
    @invite = invites(:one)
    @guest_user = @invite.user
    @event = @invite.event
    @host_user = @event.host
    @other_user = users(:three)
  end

  test "should get index when logged in as the guest" do
    log_in_as(@guest_user)
    get :index, user_id: @guest_user.id
    assert_response :success
  end

  test "should redirect index when not logged in" do
    get :index, user_id: @guest_user.id
    assert_redirected_to login_url
  end

  test "should redirect index when not logged in as the guest" do
    log_in_as(@host_user)
    get :index, user_id: @guest_user.id
    assert_redirected_to root_url
  end

  test "should get new when logged in as the host" do
    log_in_as(@host_user)
    get :new, event_id: @event.id
    assert_response :success
  end

  test "should redirect new when not logged in" do
    get :new, event_id: @event.id
    assert_redirected_to login_url
  end

  test "should redirect new when not logged in as the host" do
    log_in_as(@guest_user)
    get :new, event_id: @event.id
    assert_redirected_to root_url
  end

  test "should post create when logged in as the host" do
    log_in_as(@host_user)
    post :create, event_id: @event.id,
                  user_ids: { "#{@guest_user.id}" => "1" }
    assert_response :redirect
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Invite.count' do
      post :create, event_id: @event.id,
                    user_ids: { "#{@guest_user.id}" => "1" }
    end
    assert_redirected_to login_url
  end

  test "should redirect create when not logged in as the host" do
    log_in_as(@guest_user)
    assert_no_difference 'Invite.count' do
      post :create, event_id: @event.id, invite: { reply: "Yes",
                                                   user_id: @guest_user.id,
                                                   event_id: @event.id }
    end
    assert_redirected_to root_url
  end

  test "should get edit when logged in as the guest" do
    log_in_as(@guest_user)
    get :edit, user_id: @guest_user.id, id: @invite.id
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get :edit, user_id: @guest_user.id, id: @invite.id
    assert_redirected_to login_url
  end

  test "should redirect edit when not logged in as the guest" do
    log_in_as(@host_user)
    get :edit, user_id: @guest_user.id, id: @invite.id
    assert_redirected_to root_url
  end

  test "should patch update when logged in as the guest" do
    log_in_as(@guest_user)
    patch :update, user_id: @guest_user.id, id: @invite.id,
          invite: { reply: "No",
                    user_id: @guest_user.id,
                    event_id: @event.id }
    assert_response :redirect
  end

  test "should redirect update when not logged in" do
    assert_no_difference 'Invite.count' do
      patch :update, user_id: @guest_user.id, id: @invite.id,
            invite: { reply: "No",
                      user_id: @guest_user.id,
                      event_id: @event.id }
    end
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in as the guest" do
    log_in_as(@host_user)
    assert_no_difference 'Invite.count' do
      patch :update, user_id: @guest_user.id, id: @invite.id,
            invite: { reply: "No",
                      user_id: @guest_user.id,
                      event_id: @event.id }
    end
    assert_redirected_to root_url
  end

  test "should delete destroy when logged in as the guest" do
    log_in_as(@guest_user)
    assert_difference 'Invite.count', -1 do
      delete :destroy, id: @invite.id
    end
    assert_redirected_to root_url
  end

  test "should delete destroy when logged in as the host" do
    log_in_as(@host_user)
    assert_difference 'Invite.count', -1 do
      delete :destroy, id: @invite.id
    end
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Invite.count' do
      delete :destroy, id: @invite.id
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in as the guest or host" do
    log_in_as(@other_user)
    assert_no_difference 'Invite.count' do
      delete :destroy, id: @invite.id
    end
  end
end
