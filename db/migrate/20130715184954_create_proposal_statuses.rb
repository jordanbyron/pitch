class CreateProposalStatuses < ActiveRecord::Migration
  def change
    create_table :proposal_statuses do |t|
      t.string  :name
      t.integer :system_status_id
      t.boolean :default, null: false, default: false

      t.timestamps
    end
  end
end
