class Account < ActiveRecord::Base
  after_create :setup_database

  validates_uniqueness_of :database_name
  validates_format_of     :database_name, with: /\A[a-z\d]+([-_][a-z\d]+)*\z/i
  validates_length_of     :database_name, in: 1..60

  validates_presence_of   :company_name

  private

  def setup_database
    Apartment::Database.create(database_name)
  end
end
