class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.belongs_to :proposal
      t.string     :name
      t.integer    :position

      t.timestamps
    end
  end
end
