require "test_helper"

class Admin::CandidatesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get admin_candidates_new_url
    assert_response :success
  end

  test "should get create" do
    get admin_candidates_create_url
    assert_response :success
  end

  test "should get edit" do
    get admin_candidates_edit_url
    assert_response :success
  end

  test "should get update" do
    get admin_candidates_update_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_candidates_destroy_url
    assert_response :success
  end
end
