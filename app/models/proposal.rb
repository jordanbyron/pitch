class Proposal < ActiveRecord::Base
  has_many :groups
  has_many :rows

  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'

  belongs_to :proposal_status
end
