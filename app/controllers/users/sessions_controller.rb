class Users::SessionsController < Devise::SessionsController
	layout 'start', only: [:new]

	def new
		super		
	end
end