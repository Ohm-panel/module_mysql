require 'test_helper'

class MysqlDatabasesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mysql_databases)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mysql_database" do
    assert_difference('MysqlDatabase.count') do
      post :create, :mysql_database => { }
    end

    assert_redirected_to mysql_database_path(assigns(:mysql_database))
  end

  test "should show mysql_database" do
    get :show, :id => mysql_databases(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => mysql_databases(:one).to_param
    assert_response :success
  end

  test "should update mysql_database" do
    put :update, :id => mysql_databases(:one).to_param, :mysql_database => { }
    assert_redirected_to mysql_database_path(assigns(:mysql_database))
  end

  test "should destroy mysql_database" do
    assert_difference('MysqlDatabase.count', -1) do
      delete :destroy, :id => mysql_databases(:one).to_param
    end

    assert_redirected_to mysql_databases_path
  end
end
