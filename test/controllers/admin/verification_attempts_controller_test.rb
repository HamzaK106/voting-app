require "test_helper"

class Admin::VerificationAttemptsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_verification_attempts_index_url
    assert_response :success
  end
end
