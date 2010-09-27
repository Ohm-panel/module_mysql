require 'test_helper'

class MysqlUsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mysql_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mysql_user" do
    assert_difference('MysqlUser.count') do
      post :create, :mysql_user => { }
    end

    assert_redirected_to mysql_user_path(assigns(:mysql_user))
  end

  test "should show mysql_user" do
    get :show, :id => mysql_users(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => mysql_users(:one).to_param
    assert_response :success
  end

  test "should update mysql_user" do
    put :update, :id => mysql_users(:one).to_param, :mysql_user => { }
    assert_redirected_to mysql_user_path(assigns(:mysql_user))
  end

  test "should destroy mysql_user" do
    assert_difference('MysqlUser.count', -1) do
      delete :destroy, :id => mysql_users(:one).to_param
    end

    assert_redirected_to mysql_users_path
  end
end
