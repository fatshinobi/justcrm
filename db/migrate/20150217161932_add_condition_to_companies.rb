class AddConditionToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :condition, :integer, default: 0
    add_index :companies, :condition
  end
end
