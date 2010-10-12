### Ohm MySQL module ###
#
# Databases controller
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

class MysqlDatabasesController < MysqlController
  before_filter :authenticate_mysql_user

  def controller_name
    "MySQL"
  end

  def create
    @database = MysqlDatabase.new(params[:mysql_database])

    unless @database.mysql_login.mysql_user == @logged_mysql_user
      flash[:error] = 'Invalid login'
      redirect_to :controller => 'mysql_logins', :action => 'index'
      return
    end

    if @database.save
      flash[:notice] = "Database successfully created.#{@@changes}"
      redirect_to :controller => 'mysql_logins', :action => 'index'
    else
      flash[:error] = "Cannot create dabase.<br/>Please try another name."
      redirect_to :controller => 'mysql_logins', :action => 'index'
    end
  end

  def destroy
    @database = MysqlDatabase.find(params[:id])

    if @database.mysql_login.mysql_user == @logged_mysql_user
      @database.destroy

      flash[:notice] = @database.name + " was successfully deleted.#{@@changes}"
      redirect_to :controller => 'mysql_logins', :action => 'index'
    else
      flash[:error] = 'Invalid database'
      redirect_to :controller => 'mysql_logins', :action => 'index'
    end
  end
end

