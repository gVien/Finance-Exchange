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
end