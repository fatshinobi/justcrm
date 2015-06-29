class AddUserToOpportunities < ActiveRecord::Migration
  def change
    add_reference :opportunities, :user, index: true
  end
end
