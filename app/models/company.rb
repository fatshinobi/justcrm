class Company < ActiveRecord::Base
	include Conditionable
	has_many :company_people, 
	  :inverse_of => :company
	has_many :people, 
	  -> { where.not(
	  	   people: {
	  	   	 condition: Conditionable.condition_index(:removed)
	  	   }
	  	 )},
	  :through => :company_people

	has_many :appointments
	has_many :opportunities
	belongs_to :user

	acts_as_taggable
	acts_as_taggable_on :groups
	validates :name, presence: true
	validates :name, uniqueness: true
	validates :name, length: {minimum: 3}
	validates :user_id, presence: true

	mount_uploader :ava, AvaUploader
	paginates_per 10

	scope :contains, -> name { where("name like ?", "%#{name}%")}
end
