helpers do

	def login(user)
		session[:user_id] = user.id
	end

	def logout
		session[:user_id] = nil
	end

	def current_user
		# if there is in a session
		@user ||= User.find(session[:user_id]) if session[:user_id]
	end

	def dataExist?(symbol_field)
		Stock.new.data(symbol_field[:sym], symbol_field[:period].to_i).length > 0
	end

end