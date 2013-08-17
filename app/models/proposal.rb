class Proposal < ActiveRecord::Base
  default_scope { where(account_id: Account.current_id) }

  before_create :next_proposal_number
  after_update  :stream_update
  after_destroy :stream_destroy

  has_many :groups
  has_many :rows

  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'

  belongs_to :proposal_status

  private

  def next_proposal_number
    self.proposal_number ||= (Proposal.maximum("proposal_number") || 0) + 1
    self.revision        ||= 0
  end

  def stream_update
    stream('update', changes: changes)
  end

  def stream_destroy
    stream('destroy')
  end

  def stream(action, data = {})
    channel = "proposal_#{id}"

    Redis.new.publish channel, data.merge(
      action: action,
      item:   'proposal',
      id:     id
    ).to_json
  end

end
