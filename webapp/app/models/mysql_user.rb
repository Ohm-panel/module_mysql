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

class MysqlUser < ActiveRecord::Base
  belongs_to :user
  has_many :mysql_logins

  validates_presence_of :user_id
  validates_uniqueness_of :user_id

  def used_databases_total
    # What user uses
    used = 0
    self.mysql_logins.each do |l|
      used += l.mysql_databases.count
    end
    # What's given to sub-users
    self.user.users.each do |u|
      mysqluser = MysqlUser.find(:first, :conditions => { :user_id => u.id })
      used += mysqluser ? mysqluser.max_databases : 0
    end
    used
  end

  def free_databases
    return -1 if self.max_databases == -1
    self.max_databases - self.used_databases_total
  end

  validate :check_quota

  def check_quota
    return if self.user.nil? # Rejected anyway, don't need to crash here

    # Fill blank quotas
    self.max_databases = -1 if !self.max_databases or self.max_databases < 0

    # Root can do anything
    return if self.user.root?
    return if self.user.parent.root?

    # Compute quotas to take from parent
    oldme = self.id ? MysqlUser.find(self.id) : nil
    databases_to_take = self.max_databases - ((oldme and self.max_databases!=-1) ? oldme.max_databases : 0)

    # See if we can take that much
    parent = MysqlUser.find(:first, :conditions => { :user_id => self.user.parent.id })
    errors.add(:max_databases, "is more than you can give") unless User.quota_ok parent.free_databases, databases_to_take
  end
end

