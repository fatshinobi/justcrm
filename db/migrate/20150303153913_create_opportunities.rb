class CreateOpportunities < ActiveRecord::Migration
  def change
    create_table :opportunities do |t|
      t.string :title
      t.date :start
      t.date :finish
      t.text :description
      t.integer :stage
      t.integer :status
      t.belongs_to :company, index: true
      t.belongs_to :person, index: true

      t.timestamps
    end
  end
end
