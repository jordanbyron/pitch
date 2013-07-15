class CreateRows < ActiveRecord::Migration
  def change
    create_table :rows do |t|
      t.belongs_to :proposal
      t.belongs_to :group

      t.string     :sku
      t.string     :description
      t.integer    :quantity, default: 1
      t.decimal    :price,    default: 0.0
      t.integer    :position

      t.timestamps
    end
  end
end
