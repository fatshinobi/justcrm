class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.text :body
      t.belongs_to :company, index: true
      t.belongs_to :person, index: true
      t.datetime :when
      t.integer :status, default: 0
      t.integer :type, default: 0

      t.timestamps
    end
  end
end
