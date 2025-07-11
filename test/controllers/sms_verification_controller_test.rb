require "test_helper"

class SmsVerificationControllerTest < ActionDispatch::IntegrationTest
  test "should get request" do
    get sms_verification_request_url
    assert_response :success
  end

  test "should get verify" do
    get sms_verification_verify_url
    assert_response :success
  end
end
