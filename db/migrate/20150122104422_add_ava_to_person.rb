class AddAvaToPerson < ActiveRecord::Migration
  def change
    add_column :people, :ava, :string
  end
end
