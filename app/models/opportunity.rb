class Opportunity < ActiveRecord::Base
  include HasUser
  belongs_to :company
  belongs_to :person
  belongs_to :user

  has_many :appointments
  
  validates :title, presence: true
  validates :title, length: {minimum: 4}
  validates :user, presence: true
  validates :company, presence: true

  validate :person_must_match_to_company

  scope :by_stage, ->(stage, user) {where(stage: STAGES_LIST.index(stage)).where(user: user).where(status: STATUS_LIST.index(Open))}
  scope :by_user, ->(user) {where(user: user).where(status: STATUS_LIST.index(Open))}
  scope :overdue, ->(user) {where(user: user).where(status: STATUS_LIST.index(Open)).where("`finish` < ?", Date.current)}
  default_scope {order('`start` DESC')} 

  class Status
    def self.value 
    end
    def self.name
    end
  end

  class Open < Status
    def self.value; :open; end
    def self.name; 'Open'; end
  end

  class Finished < Status
    def self.value; :finished; end
    def self.name; 'Finish'; end
  end

  class Canceled < Status
    def self.value; :canceled; end
    def self.name; 'Cancel'; end
  end

  STAGES_LIST = [:awareness, :interest, :decision, :buy]

  STATUS_LIST = [ 
    Open, Finished, Canceled
  ]

  def person_must_match_to_company
  	return if !person
  	company.company_people.each do |link|
  		return if link.person == person
  	end
  	errors.add(:person, "Person must present the company")
  end

  def get_stage
    STAGES_LIST[stage]
  end

  def set_stage(stage_name)
    self.stage = STAGES_LIST.index(stage_name)
  end

  def next_stage
    self.stage += 1 if self.stage < 3
  end

  def prev_stage
    self.stage -= 1 if self.stage > 0
  end

  def is_last_stage?
    self.stage == 3
  end

  def is_first_stage?
    self.stage == 0
  end

  def get_status
    STATUS_LIST[status].value()
  end

  def set_status(status_name)
    status = self.class.const_get(status_name.to_s.capitalize)
    index = STATUS_LIST.index(status)
    if index then
      self.status = index
    else
      raise IndexError
    end
  end

  def self.statuses
    STATUS_LIST
  end
end
