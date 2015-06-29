class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.text :about
      t.string :phone
      t.string :facebook
      t.string :twitter
      t.string :web

      t.timestamps
    end
  end
end
