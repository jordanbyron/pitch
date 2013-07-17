class Proposal < ActiveRecord::Base
  has_many :groups, autosave: true
  has_many :rows,   autosave: true

  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'

  belongs_to :proposal_status

  accepts_nested_attributes_for :groups, allow_destroy: true

  def rows_attributes=(attributes)
    RowAttributes.new(self, attributes)
  end
end
