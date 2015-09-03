require 'active_support/concern'

module HasUser
  extend ActiveSupport::Concern	
  delegate :name, to: :user, allow_nil: true, prefix: true
end