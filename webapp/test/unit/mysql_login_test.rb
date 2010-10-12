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

class MysqlLoginTest < ActiveSupport::TestCase
  test "valid fixtures" do
    assert mysql_logins(:one).valid?, "fixtures: one is invalid"
    assert mysql_logins(:two).valid?, "fixtures: two is invalid"
  end

  test "invalid without username or password" do
    login = MysqlLogin.new
    login.save
    assert login.errors.invalid?(:username), "Blank username accepted"
    assert login.errors.invalid?(:password), "Blank password accepted"
  end

  test "password change" do
    login = mysql_logins(:one)
    login.password = "new password"
    login.password_confirmation = login.password
    assert login.valid?, "Good new password rejected"

    login.password_confirmation = "something else"
    login.save
    assert login.errors.invalid?(:password_confirmation), "Incorrect password confirmation accepted"
  end

  test "username format" do
    login = mysql_logins(:one)
    login.username = "valid_username-ok"
    assert login.valid?, "Good username rejected"

    login.username = "000invalid_username"
    login.save
    assert login.errors.invalid?(:username), "Bad username accepted"

    login.username = "invalid username"
    login.save
    assert login.errors.invalid?(:username), "Bad username accepted"

    login.username = "invalid/username"
    login.save
    assert login.errors.invalid?(:username), "Bad username accepted"
  end

  test "username unique" do
    login = MysqlLogin.new(:username  => mysql_logins(:one).username,
                           :password  => "some password")
    login.save
    assert login.errors.invalid?(:username), "Duplicate username accepted"
  end
end

