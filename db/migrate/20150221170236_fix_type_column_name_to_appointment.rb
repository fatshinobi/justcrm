class FixTypeColumnNameToAppointment < ActiveRecord::Migration
  def change
  	rename_column :appointments, :type, :communication_type
  end
end
