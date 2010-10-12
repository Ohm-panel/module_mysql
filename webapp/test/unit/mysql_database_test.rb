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

require 'test_helper'

class MysqlDatabaseTest < ActiveSupport::TestCase
  test "valid fixtures" do
    assert mysql_databases(:one).valid?, "fixtures: one is invalid"
    assert mysql_databases(:two).valid?, "fixtures: two is invalid"
  end

  test "invalid without name" do
    db = MysqlDatabase.new
    db.save
    assert db.errors.invalid?(:name), "Blank name accepted"
  end

  test "name format" do
    db = mysql_databases(:one)
    db.name = "valid_dbname-ok"
    assert db.valid?, "Good name rejected"

    db.name = "000invalid_name"
    db.save
    assert db.errors.invalid?(:name), "Bad name accepted"

    db.name = "invalid name"
    db.save
    assert db.errors.invalid?(:name), "Bad name accepted"

    db.name = "invalid/name"
    db.save
    assert db.errors.invalid?(:name), "Bad name accepted"
  end

  test "name unique" do
    db = MysqlDatabase.new(:name  => mysql_databases(:one).name)
    db.save
    assert db.errors.invalid?(:name), "Duplicate name accepted"
  end
end

