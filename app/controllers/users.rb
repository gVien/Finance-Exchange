# load main page
get "/" do
	redirect "/login"
end

# load signup page
get "/signup" do
	erb :signup
end

# redirect to user account page
get "/users/:user_id" do
  if current_user #session[:user_id] != nil
  	@current_user = current_user
    @comment = Comment.all
  	erb :show
  else
    redirect "/login"
  end
end

post "/signup" do
	@new_user = User.create(params[:user])
	login(@new_user)
	redirect "/users/#{@new_user.id}"
end
