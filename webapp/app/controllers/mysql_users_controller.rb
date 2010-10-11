### Ohm MySQL module ###
#
# Users controller
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

class MysqlUsersController < MysqlController
  before_filter :authenticate_mysql_user

  def controller_name
    "MySQL"
  end

  def show
    if params[:user_id]
      @mysql_user = MysqlUser.find(:first, :conditions => { :user_id => params[:user_id] })
    elsif params[:id]
      @mysql_user = MysqlUser.find(params[:id])
    end
  end

  def new
    @mysql_user = MysqlUser.new(:user_id => params[:user_id])
    @user = User.find(params[:user_id])
  end

  def edit
    @mysql_user = MysqlUser.find(params[:id])
  end

  def create
    @mysql_user = MysqlUser.new(params[:mysql_user])

    if @mysql_user.save
      flash[:notice] = 'MySQL service successfully added.'
      redirect_to @mysql_user.user
    else
      render :action => "new"
    end
  end

  def update
    @mysql_user = MysqlUser.find(params[:id])

    if @mysql_user.update_attributes(params[:mysql_user])
      flash[:notice] = 'MySQL user was successfully updated.'
      redirect_to(@mysql_user)
    else
      render :action => "edit"
    end
  end
end

