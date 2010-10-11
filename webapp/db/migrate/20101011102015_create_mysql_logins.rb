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

