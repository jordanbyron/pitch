class Proposal < ActiveRecord::Base
  has_many :groups
  has_many :rows

  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'

  belongs_to :proposal_status

  accepts_nested_attributes_for :groups, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :rows,   reject_if: :all_blank, allow_destroy: true
end
