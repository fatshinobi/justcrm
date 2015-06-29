class Appointment < ActiveRecord::Base
  belongs_to :company
  belongs_to :person
  belongs_to :user
  belongs_to :opportunity

  after_initialize :when_initialize

  validate :person_must_match_to_company
  validates :company, presence: true
  validates :user, presence: true

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

  class Done < Status
    def self.value; :done; end
    def self.name; 'Done'; end
  end

  STATUS_LIST = [Open, Done]  

  COMMUNICATION_TYPES_LIST = [:message, :call, :task, :meet]

  default_scope {order('`when` DESC')} 
  scope :current, ->(date, user) {where(user: user).where("`when` > ? and `when` <= ?", DateTime.new(date.year, date.month, date.day, 0, 0, 1), DateTime.new(date.year, date.month, date.day, 0, 0, 0) + 1.day).order('`when`')}
  scope :overdue, ->(user) {where(user: user).where(status: STATUS_LIST.index(Open)).where("`when` < ?", DateTime.new(Date.current.year, Date.current.month, Date.current.day, 0, 0, 0)).order('`when`')}

  class CommunicationType
    def initialize(index, value)
      self.index = index
      self.value = value
    end
    attr_accessor :index, :value
  end

  def when_initialize
    self.when = DateTime.now if !self.when
  end

  def person_must_match_to_company
  	return if !person
  	company.company_people.each do |link|
  		return if link.person == person
  	end
  	errors.add(:person, "Person must present the company")
  end

  def get_communication_type
    COMMUNICATION_TYPES_LIST[self.communication_type]
  end

  def set_communication_type(communication_type)
    self.communication_type = COMMUNICATION_TYPES_LIST.index(communication_type)
  end

  def self.communication_types
    types_list = []
    COMMUNICATION_TYPES_LIST.each do |type_name|
      types_list << CommunicationType.new(COMMUNICATION_TYPES_LIST.index(type_name), type_name.to_s)
    end
    types_list
  end

  def get_status
    STATUS_LIST[self.status].value
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

  def is_message?
    get_communication_type == :message
  end

  def is_call?
    get_communication_type == :call
  end

  def is_task?
    get_communication_type == :task
  end

  def is_meet?
    get_communication_type == :meet
  end

  def is_open?
    get_status == :open
  end

  def is_done?
    get_status == :done
  end

  def self.statuses
    STATUS_LIST
  end
end
