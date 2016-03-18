require 'test_helper'

class EventsShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @event = events(:one)
    @invites = @event.invites
    @non_hosted_event = events(:two)
    @non_hosted_invites = @non_hosted_event.invites
  end

  test "show event page with invites sidebar" do
    log_in_as(@user)
    get event_path(@event)
    assert_template "events/show"
    assert_select "title", full_title(@event.name)
    assert_select "h1", text: @event.name
    assert_match @event.description, response.body
    assert_match formatted_date(@event.event_date, "Begins on "),
                 response.body
    assert_select "a", text: "delete"

    # Total invite count
    assert_match @invites.count.to_s, response.body

    # Yes invites
    assert_match @invites.where('reply' => 'yes').count.to_s, response.body
    @invites.where('reply' => 'yes').each do |invite|
      assert_select "a[href=?]", user_path(invite.user_id),
                                 text: invite.user.name
      assert_select "a", text: "uninvite"
    end

    # No invites
    assert_match @invites.where('reply' => 'no').count.to_s, response.body
    @invites.where('reply' => 'no').each do |invite|
      assert_select "a[href=?]", user_path(invite.user_id),
                                 text: invite.user.name
      assert_select "a", text: "uninvite"
    end

    # Undecided invites
    assert_match @invites.where('reply' => 'none').count.to_s, response.body
    @invites.where('reply' => 'none').each do |invite|
      assert_select "a[href=?]", user_path(invite.user_id),
                                 text: invite.user.name
      assert_select "a", text: "uninvite"
    end

    assert_difference "Event.count", -1 do
      delete event_path(@event)
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_template "static_pages/home"

    # Demonstrate lack of delete and uninvite links for non-hosted event
    get event_path(@non_hosted_event)
    assert_template "events/show"
    assert_select "title", full_title(@non_hosted_event.name)
    assert_select "h1", text: @non_hosted_event.name
    assert_match @non_hosted_event.description, response.body
    assert_match formatted_date(@event.event_date, "Begins on "),
                 response.body
    assert_select "a", text: "delete", count: 0

    # Total invite count
    assert_match @non_hosted_invites.count.to_s, response.body

    # Yes invites
    assert_match @non_hosted_invites.where('reply' => 'yes').count.to_s,
                 response.body
    @non_hosted_invites.where('reply' => 'yes').each do |invite|
      assert_select "a[href=?]", user_path(invite.user_id),
                                 text: invite.user.name
      assert_select "a", text: "uninvite", count: 0                        
    end

    # No invites
    assert_match @non_hosted_invites.where('reply' => 'no').count.to_s, 
                 response.body
    @non_hosted_invites.where('reply' => 'no').each do |invite|
      assert_select "a[href=?]", user_path(invite.user_id),
                                 text: invite.user.name
      assert_select "a", text: "uninvite", count: 0                      
    end

    # Undecided invites
    assert_match @non_hosted_invites.where('reply' => 'none').count.to_s,
                 response.body
    @non_hosted_invites.where('reply' => 'none').each do |invite|
      assert_select "a[href=?]", user_path(invite.user_id),
                                 text: invite.user.name
      assert_select "a", text: "uninvite", count: 0
    end
  end
end
