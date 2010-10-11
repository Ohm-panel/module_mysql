# Ohm - Open Hosting Manager <http://ohmanager.sourceforge.net>
# MySQL module - Logins controller
#
# Copyright (C) 2009-2010 UMONS <http://www.umons.ac.be>
#
# This file is part of Ohm.
#
# Ohm is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ohm is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ohm. If not, see <http://www.gnu.org/licenses/>.

class MysqlLoginsController < MysqlController
  before_filter :authenticate_mysql_user

  def controller_name
    "MySQL"
  end

  def index
    @logins = @logged_mysql_user.mysql_logins
    @database = MysqlDatabase.new
  end

  def new
    @login = MysqlLogin.new
  end

  def edit
    @login = MysqlLogin.find(params[:id])

    unless @login.mysql_user == @logged_mysql_user
      flash[:error] = 'Invalid login'
      redirect_to :action => 'index'
    end
  end

  def create
    @login = MysqlLogin.new(params[:mysql_login])
    @login.mysql_user = @logged_mysql_user

    if @login.save
      flash[:notice] = "Login successfully created.#{@@changes}"
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def update
    @login = MysqlLogin.find(params[:id])
    @newatts = params[:mysql_login]
    if @newatts[:password] == ''
      @newatts[:password_confirmation] = nil
      @newatts[:password] = @login.password
    end

    if not @login.mysql_user == @logged_mysql_user
      flash[:error] = 'Invalid login'
      redirect_to :action => 'index'
    elsif @login.update_attributes(params[:mysql_login])
      flash[:notice] = @login.username + " was successfully updated.#{@@changes}"
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def destroy
    @login = MysqlLogin.find(params[:id])

    if @login.mysql_user == @logged_mysql_user
      @login.destroy

      flash[:notice] = @login.username + " was successfully deleted.#{@@changes}"
      redirect_to :action => 'index'
    else
      flash[:error] = 'Invalid login'
      redirect_to :action => 'index'
    end
  end
end

