class CreateCompanyPeople < ActiveRecord::Migration
  def change
    create_table :company_people do |t|
      t.references :company, index: true
      t.references :person, index: true
      t.string :role

      t.timestamps
    end
  end
end
