class Row < ActiveRecord::Base
  default_scope { where(account_id: Account.current_id) }

  belongs_to :proposal
  belongs_to :group

  def position
    self[:position] || 0
  end
end
