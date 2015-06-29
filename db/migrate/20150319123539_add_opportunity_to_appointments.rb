class AddOpportunityToAppointments < ActiveRecord::Migration
  def change
    add_reference :appointments, :opportunity, index: true
  end
end
