# load main page
get "/" do
	redirect "/login"
end

# load signup page
get "/signup" do
	erb :signup
end

post "/signup" do
	@new_user = User.create(params[:user])
	login(@new_user)
	redirect "/stocks"
end
