class Group < ActiveRecord::Base
  default_scope { where(account_id: Account.current_id) }

  belongs_to :proposal
  has_many   :rows

  def position
    self[:position] || 0
  end
end
