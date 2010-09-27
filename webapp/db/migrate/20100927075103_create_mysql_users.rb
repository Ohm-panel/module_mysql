class CreateMysqlUsers < ActiveRecord::Migration
  def self.up
    create_table :mysql_users do |t|
      t.integer :user_id
      t.integer :max_databases

      t.timestamps
    end
  end

  def self.down
    drop_table :mysql_users
  end
end

