class AddDefaultValueForConditionToUsers < ActiveRecord::Migration
  def up
  	change_column :users, :condition, :integer, :default => 0
  end

  def down
  	change_column :users, :condition, :integer, :default => nil
  end

end
