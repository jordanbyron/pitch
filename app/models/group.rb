class Group < ActiveRecord::Base
  belongs_to :proposal
  has_many   :rows

  accepts_nested_attributes_for :rows,   allow_destroy: true

  def position
    self[:position] || 0
  end
end
