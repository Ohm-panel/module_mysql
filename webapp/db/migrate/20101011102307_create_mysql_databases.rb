class CreateMysqlDatabases < ActiveRecord::Migration
  def self.up
    create_table :mysql_databases do |t|
      t.integer :mysql_login_id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :mysql_databases
  end
end
