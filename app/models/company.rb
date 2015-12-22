class Company < ActiveRecord::Base
  include Conditionable, HasUser
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

  mount_uploader :ava, AvaUploader
  paginates_per 10

  scope :contains, -> name { where("name like ?", "%#{name}%")}
  default_scope {order(:created_at)}

  delegate :unremoved, to: :company_people, allow_nil: true, prefix: true

end
