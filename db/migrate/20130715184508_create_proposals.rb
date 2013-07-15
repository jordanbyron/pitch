class CreateProposals < ActiveRecord::Migration
  def change
    create_table :proposals do |t|
      t.integer :created_by_id
      t.integer :updated_by_id
      t.integer :proposal_number
      t.integer :revision
      t.text    :description

      t.string     :customer_name
      t.belongs_to :proposal_status

      t.timestamps
    end
  end
end
