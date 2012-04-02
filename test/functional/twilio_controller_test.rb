require 'test_helper'

class TwilioControllerTest < ActionController::TestCase
  test "should get event" do
    get :event
    assert_response :success
  end

  test "should get decisions" do
    get :decisions
    assert_response :success
  end

  test "should get options" do
    get :options
    assert_response :success
  end

  test "should get vote" do
    get :vote
    assert_response :success
  end

end
