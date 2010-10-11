class MysqlDatabase < ActiveRecord::Base
  belongs_to :mysql_login

  validates_uniqueness_of :name
end

