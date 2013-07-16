class Group < ActiveRecord::Base
  belongs_to :proposal
  has_many   :rows

  def position
    self[:position] || 0
  end
end
