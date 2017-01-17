require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bob)
    @non_activated = users(:ricky)
  end

  test "should redirect to users_path if user is not activated" do
    log_in_as(@user)
    get user_path(@non_activated)
    assert_redirected_to users_path
  end
end