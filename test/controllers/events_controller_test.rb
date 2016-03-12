require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  def setup
    @event = events(:one)
    @non_host = users(:two)
  end

  test "should redirect show when not logged in" do
    get :show, id: @event
    assert_redirected_to login_url
  end

  test "should redirect new when not logged in" do
    get :new
    assert_redirected_to login_url
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Event.count' do
      post :create, event: { name: "Ex", description: "Lorem ipsum.",
                             event_date: Time.now }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Event.count' do
      delete :destroy, id: @event
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not the host" do
    log_in_as(@non_host)
    assert_no_difference 'Event.count' do
      delete :destroy, id: @event
    end
    assert_redirected_to root_url
  end
end
