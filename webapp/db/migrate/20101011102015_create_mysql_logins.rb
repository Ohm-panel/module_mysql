### Ohm MySQL module ###
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

class CreateMysqlLogins < ActiveRecord::Migration
  def self.up
    create_table :mysql_logins do |t|
      t.integer :mysql_user_id
      t.string :username
      t.string :password

      t.timestamps
    end
  end

  def self.down
    drop_table :mysql_logins
  end
end

