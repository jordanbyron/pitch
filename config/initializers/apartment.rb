Apartment.configure do |config|
  config.excluded_models = ["Account"]
  config.database_names  = -> { Account.pluck(:database_name) }
end
