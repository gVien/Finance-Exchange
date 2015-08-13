# route to login page
get "/login" do
	if current_user
		redirect "/stocks"
	else
		erb :login
	end
end

# authenticate login and redirect to user account page
post "/login" do
	user = User.find_by(email: params[:email])
	p "The login user is #{user}"
	if user && user.authenticate(params[:password])
		login(user)
		redirect "/stocks"
	else
		@error = "You have entered the wrong email or password! Please try again!"
		erb :login
	end
end

get "/logout" do
	logout
	redirect "/login"
end
