class CompanyPerson < ActiveRecord::Base
  belongs_to :company
  belongs_to :person
  validates :company, presence: true
  validates :person, presence: true  

  scope :unremoved, -> {joins(:person).where("people.condition != ?", Conditionable.condition_index(:removed)).joins(:company).where("companies.condition != ?", Conditionable.condition_index(:removed))}  

  attr_accessor :new_company_name
end
