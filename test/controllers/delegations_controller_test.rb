require "test_helper"

class DelegationsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get delegations_show_url
    assert_response :success
  end

  test "should get edit" do
    get delegations_edit_url
    assert_response :success
  end

  test "should get update" do
    get delegations_update_url
    assert_response :success
  end
end
