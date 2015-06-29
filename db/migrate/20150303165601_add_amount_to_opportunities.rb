class AddAmountToOpportunities < ActiveRecord::Migration
  def change
    add_column :opportunities, :amount, :decimal, precision: 8, scale: 2
  end
end
