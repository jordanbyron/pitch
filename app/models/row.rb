class Row < ActiveRecord::Base
  belongs_to :proposal
  belongs_to :group

  def position
    self[:position] || 0
  end
end
