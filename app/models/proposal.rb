class Proposal < ActiveRecord::Base
  default_scope { where(account_id: Account.current_id) }

  before_create :next_proposal_number

  has_many :groups, autosave: true
  has_many :rows,   autosave: true

  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'

  belongs_to :proposal_status

  private

  def next_proposal_number
    self.proposal_number ||= (Proposal.maximum("proposal_number") || 0) + 1
    self.revision        ||= 0
  end
end
