class AddConditionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :condition, :integer
    add_index :users, :condition
  end
end
