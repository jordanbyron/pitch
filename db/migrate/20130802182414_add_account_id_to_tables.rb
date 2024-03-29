class AddAccountIdToTables < ActiveRecord::Migration
  def change
    %w[proposals proposal_statuses users rows groups].each do |table|
      add_column table, :account_id, :integer
      add_index  table, :account_id
    end
  end
end
