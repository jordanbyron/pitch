class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :company_name
      t.string :database_name

      t.timestamps
    end
  end
end
