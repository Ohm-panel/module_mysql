### Ohm MySQL module ###
#
# Daemon
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

class Ohmd_mysql
  def self.install
    # Install MySQL 5.1 and PHP-MySQL
    system "apt-get install -y mysql-server-5.1 mysql-client-5.1 php5-mysql" \
      or return false

    # Ask for root password
    root_pwd = nil
    while(root_pwd==nil) do
      print "Root MySQL password: "
      root_pwd = readline.strip
      unless(mysql_exec root_pwd, "SELECT 'Works!' as 'It'")
        root_pwd = nil
        puts "Sorry, try again"
      end
    end

    # Install SQLBuddy
    system "rm -rf /var/www/ohm/public/sqlbuddy"
    system "chown -R www-data:www-data mysql/sqlbuddy_1_3_2_ohm"
    system "mv mysql/sqlbuddy_1_3_2_ohm /var/www/ohm/public/sqlbuddy"

    true
  end


  def self.remove
    system "apt-get remove -y mysql-server-5.1 mysql-client-5.1 php5-mysql"
  end


  def self.exec
    # Check for orphan databases, logins and users first
    MysqlUser.all.select { |u| u.user.nil? }.each do |orphan|
      orphan.destroy
    end
    MysqlLogin.all.select { |l| l.mysql_user.nil? }.each do |orphan|
      mysql_exec(root_pwd, "DROP USER '#{orphan.username}'")
        or return false
      orphan.destroy
    end
    MysqlDatabase.all.select { |d| d.mysql_login.nil? }.each do |orphan|
      mysql_exec(root_pwd, "DROP DATABASE '#{orphan.name}'")
        or return false
      orphan.destroy
    end

    # Retreive root password
    root_pwd = 'toor'

    MysqlUser.all.each do |u|
      # Add logins
      u.mysql_logins.each do |l|
        result = mysql_exec(root_pwd, "CREATE USER '#{l.username}' IDENTIFIED BY '#{l.password}'", true)
        unless result
          mysql_exec(root_pwd, "SET PASSWORD FOR '#{l.username}' = password('#{l.password}')")
            or return false
        end

        # Add databases and privileges
        l.mysql_databases.each do |d|
          result = mysql_exec(root_pwd, "USE #{d.name}", true)
          unless result
            mysql_exec(root_pwd, "CREATE DATABASE #{d.name}")
              or return false
          end
          mysql_exec(root_pwd, "GRANT ALL PRIVILEGES ON #{d.name}.* TO #{l.username}")
            or return false
        end
      end
    end

  end

private

  def self.mysql_exec password, command, quiet=false
    log = ""
    if quiet
      log = "> /dev/null 2>&1"
    end
    command = command.split('"').join('\\"')
    system("mysql -u root -p#{password} -D mysql -e \"#{command}\" #{log}")
  end
end

