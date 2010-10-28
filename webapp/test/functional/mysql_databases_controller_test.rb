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

class MysqlDatabasesControllerTest < ActionController::TestCase
  test "should create mysql_database" do
    login_as users(:one)
    assert_difference('MysqlDatabase.count') do
      post :create, :mysql_database => { :name => 'new_db', :mysql_login_id => 1 }
    end

    assert_redirected_to :controller => 'mysql_logins', :action => 'index'
  end

  test "should destroy mysql_database" do
    login_as users(:one)
    assert_difference('MysqlDatabase.count', -1) do
      delete :destroy, :id => mysql_databases(:one).to_param
    end

    assert_redirected_to :controller => 'mysql_logins', :action => 'index'
  end
end

