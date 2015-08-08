

# get stock symbol information with specific period interval
get "/users/:user_id/:sym/:period" do
	if request.xhr?
		@period = params[:period]
		@current_user = current_user
		@comment = Comment.all
		@data = Stock.new.data(params[:sym], params[:period].to_i)
		@sym = @data.first.symbol.downcase	#why can't I put this in "action" of the form?!?!
		@stock = Stock.find_by(symbol: params[:sym])
		@plot_data_img = Stock.plot(@sym, @period.to_i)
		erb :comment, layout: false, locals: {comment: @comment}
	else
		redirect "/users/#{params[:user_id]}/#{params[:sym]}/#{params[:period]}"
	end
end

post "/users/:user_id" do
	user = User.find(params[:user_id])
	if current_user	#is in session
		login(user)
		params[:period] = 30 if params[:period] == ""
		Stock.create(symbol: params[:symbol])
		redirect "/users/#{params[:user_id]}/#{params[:symbol]}/#{params[:period]}"
	else
		redirect "/login"
	end
end

post "/users/:user_id/:sym/:period" do
	stock = Stock.find_by(symbol: params[:sym])
	Comment.create(comment: params[:comment], stock_id: stock.id, user_id: params[:user_id])
	redirect "/users/#{params[:user_id]}/#{params[:sym]}/#{params[:period]}"
end
