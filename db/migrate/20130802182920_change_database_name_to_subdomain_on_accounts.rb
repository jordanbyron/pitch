class ChangeDatabaseNameToSubdomainOnAccounts < ActiveRecord::Migration
  def change
    rename_column :accounts, :database_name, :subdomain
  end
end
