class Row < ActiveRecord::Base
  belongs_to :proposal
  belongs_to :group
end
