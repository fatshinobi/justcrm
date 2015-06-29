class AddIndexStartToOpportunities < ActiveRecord::Migration
  def change
  	add_index :opportunities, :start
  end
end
