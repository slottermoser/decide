require 'test_helper'

class DiscussionControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get get_entries" do
    get :get_entries
    assert_response :success
  end

  test "should get add_entry" do
    get :add_entry
    assert_response :success
  end

end
