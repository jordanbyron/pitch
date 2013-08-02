class Account < ActiveRecord::Base
  validates_uniqueness_of :subdomain
  validates_format_of     :subdomain, with: /\A[a-z\d]+([-_][a-z\d]+)*\z/i
  validates_length_of     :subdomain, in: 1..60

  validates_presence_of   :company_name

  def self.current_id=(id)
    Thread.current[:account_id] = id
  end

  def self.current_id
    Thread.current[:account_id]
  end
end
