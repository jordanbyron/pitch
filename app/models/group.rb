class Group < ActiveRecord::Base
  belongs_to :proposal
  has_many   :rows, autosave: true

  def position
    self[:position] || 0
  end

  def rows_attributes=(attributes)
    RowAttributes.new(self, attributes)
  end
end
