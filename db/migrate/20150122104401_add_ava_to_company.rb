class AddAvaToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :ava, :string
  end
end
