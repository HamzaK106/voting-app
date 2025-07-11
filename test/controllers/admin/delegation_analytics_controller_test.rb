require "test_helper"

class Admin::DelegationAnalyticsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_delegation_analytics_index_url
    assert_response :success
  end
end
