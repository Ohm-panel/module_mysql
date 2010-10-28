### Ohm MySQL module <http://joelcogen.com/projects/ohm/> ###
#
# Main controller
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

class MysqlController < ApplicationController
  before_filter :authenticate

  def controller_name
    "MySQL"
  end

  def authenticate_mysql_user
    @logged_mysql_user = MysqlUser.find(:first, :conditions => { :user_id => @logged_user })
    if @logged_mysql_user
      true
    elsif @logged_user.root?
      # Create an unlimited account for root and return it
      @logged_mysql_user = MysqlUser.new(:user_id       => @logged_user.id,
                                         :max_databases => -1)
      @logged_mysql_user.save
      true
    else
      flash[:error] = "You don't have access to this service. If you think you should, please contact your administrator."
      redirect_to :controller => 'dashboard'
      false
    end
  end

  def index
    redirect_to :controller => 'mysql_logins'
  end

  def addtodomain
    # This service is not "per domain"
    @domain = Domain.find(params[:domain_id])
    @service = Service.find(params[:service_id])
    @domain.services.delete @service

    flash[:error] = "This is a global service, you cannot add it to a domain"
    redirect_to @domain
  end

  def addtouser
    redirect_to :controller => 'mysql_users', :action => 'new', :user_id => params[:user_id]
  end

  def removefromuser
    usertodel = MysqlUser.find(:first, :conditions => { :user_id => params[:user_id] })
    usertodel.destroy unless usertodel.nil?

    flash[:notice] = "Service removed"
    redirect_to User.find(params[:user_id])
  end

  def showuser
    redirect_to :controller => 'mysql_users', :action => 'show', :user_id => params[:user_id]
  end

  def sqlbuddy
    redirect_to '/sqlbuddy/index.php'
  end
end

