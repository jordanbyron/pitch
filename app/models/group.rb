class Group < ActiveRecord::Base
  belongs_to :proposal
  has_many   :rows
end
