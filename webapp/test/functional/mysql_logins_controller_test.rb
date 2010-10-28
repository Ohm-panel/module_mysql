### Ohm MySQL module <http://joelcogen.com/projects/ohm/> ###
#
# Copyright (C) 2010 Joel Cogen <http://joelcogen.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this module. If not, see <http://www.gnu.org/licenses/>.

require 'test_helper'
class MysqlLoginsControllerTest < ActionController::TestCase
  test "should get index" do
    login_as users(:one)
    get :index
    assert_response :success
    assert_not_nil assigns(:logins)
  end

  test "should get new" do
    login_as users(:one)
    get :new
    assert_response :success
  end

  test "should create mysql_login" do
    login_as users(:one)
    assert_difference('MysqlLogin.count') do
      post :create, :mysql_login => { :username => 'new_user', :password => 'x', :password_confirmation => 'x' }
    end

    assert_redirected_to :controller => 'mysql_logins', :action => 'index'
  end

  test "should get edit" do
    login_as users(:one)
    get :edit, :id => mysql_logins(:one).to_param
    assert_response :success
  end

  test "should update mysql_login" do
    login_as users(:one)
    put :update, :id => mysql_logins(:one).to_param, :mysql_login => { :password => 'y', :password_confirmation => 'y' }
    assert_redirected_to :controller => 'mysql_logins', :action => 'index'
  end

  test "should refuse to update" do
    login_as users(:two)
    put :update, :id => mysql_logins(:one).to_param, :mysql_login => { :password => 'y', :password_confirmation => 'y' }
    assert_redirected_to :controller => 'mysql_logins', :action => 'index'
    assert flash[:error]
  end

  test "should destroy mysql_login" do
    login_as users(:one)
    assert_difference('MysqlLogin.count', -1) do
      delete :destroy, :id => mysql_logins(:one).to_param
    end

    assert_redirected_to :controller => 'mysql_logins', :action => 'index'
  end
end

