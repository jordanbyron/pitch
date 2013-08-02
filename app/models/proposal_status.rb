class ProposalStatus < ActiveRecord::Base
  default_scope { where(account_id: Account.current_id) }

  has_many :proposals
end
