class AddConditionToPeople < ActiveRecord::Migration
  def change
    add_column :people, :condition, :integer, default: 0
    add_index :people, :condition
  end
end
