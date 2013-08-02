class User < ActiveRecord::Base
  default_scope { where(account_id: Account.current_id) }

  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
    :validatable, :lockable

  validates_presence_of :first_name, :last_name
  validates_uniqueness_of :email, scope: :account_id
end
