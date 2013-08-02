class Proposal < ActiveRecord::Base
  default_scope { where(account_id: Account.current_id) }

  has_many :groups, autosave: true
  has_many :rows,   autosave: true

  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'

  belongs_to :proposal_status
end
