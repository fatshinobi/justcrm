class AddIndexWhenToAppointments < ActiveRecord::Migration
  def change
  	add_index :appointments, :when
  end
end
