# route to login page
get "/login" do
	erb :index
end

# authenticate login and redirect to user account page
post "/login" do
	user = User.find_by(email: params[:email])
	p "The login user is #{user}"
	if user && user.authenticate(params[:password])
		login(user)
		redirect "/users/#{user.id}"
	else
		@error = "You have entered the wrong email or password! Please try again!"
		erb :index
	end
end

get "/logout" do
	logout
	redirect "/login"
end
