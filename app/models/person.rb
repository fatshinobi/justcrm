class Person < ActiveRecord::Base
  include Conditionable, HasUser
  has_many :company_people, :inverse_of => :person
  accepts_nested_attributes_for :company_people, allow_destroy: true

  has_many :appointments
  has_many :opportunities	
  belongs_to :user

  acts_as_taggable
  acts_as_taggable_on :groups
		
  validates :name, presence: true
  validates :name, length: {minimum: 3}
	
  mount_uploader :ava, AvaUploader
  paginates_per 10	

  scope :contains, -> name { where("name like ?", "%#{name}%")}	
  default_scope {order(:created_at)}
  
  delegate :unremoved, to: :company_people, allow_nil: true, prefix: true	

end
