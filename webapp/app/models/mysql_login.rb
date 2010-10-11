class MysqlLogin < ActiveRecord::Base
  belongs_to :mysql_user
  has_many :mysql_databases

  validates_uniqueness_of :username
  validate :passwords_match

  attr_accessor :password_confirmation

  def passwords_match
    errors.add(:password_confirmation, "doesn't match password") if password_confirmation and password_confirmation != password
  end
end

