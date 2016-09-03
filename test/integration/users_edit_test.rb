require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bob)
    @another_user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: " ",
                                              email: "invalid@invalid",
                                              password: "foo",
                                              password_confirmation: "bar" }}
    assert_template 'users/edit'
    assert_select "div.alert", "The form contains 4 errors."
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    assert_equal session[:forwarding_url], edit_user_url(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "Foo Bar"
    email = "foobar@example.com"
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: "",
                                              password_confirmation: "" }}
    assert_not flash.empty?
    assert_redirected_to user_path(@user)
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: "Foo Bar",
                                              email: "foobar@example.com",
                                              password: "",
                                              password_confirmation: "" }}
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@another_user)
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to root_path
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@another_user)
    patch user_path(@user), params: { user: { name: "Foo Bar",
                                              email: "foobar@example.com",
                                              password: "",
                                              password_confirmation: "" }}
    assert_not flash.empty?
    assert_redirected_to root_path
  end
end
