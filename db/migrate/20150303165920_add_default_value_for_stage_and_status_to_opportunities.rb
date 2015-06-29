class AddDefaultValueForStageAndStatusToOpportunities < ActiveRecord::Migration
  def change
	change_column :opportunities, :stage, :integer, :default => 0 	
	change_column :opportunities, :status, :integer, :default => 0
  end

  def down
	change_column :opportunities, :stage, :integer, :default => nil
	change_column :opportunities, :status, :integer, :default => nil
  end  
end
