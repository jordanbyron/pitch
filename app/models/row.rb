class Row < ActiveRecord::Base
  default_scope { where(account_id: Account.current_id) }

  belongs_to :proposal
  belongs_to :group

  after_create  :stream_create
  after_update  :stream_update
  after_destroy :stream_destroy

  def position
    self[:position] || 0
  end

  private

  def stream_create
    stream('create')
  end

  def stream_update
    stream('update', changes: changes)
  end

  def stream_destroy
    stream('destroy')
  end

  def stream(action, data = {})
    channel = "proposal_#{proposal_id}"

    Redis.new.publish channel, data.merge(
      action: action,
      item:   'row',
      id:     id
    ).to_json
  end
end
