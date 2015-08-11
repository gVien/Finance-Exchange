

# get stock symbol information with specific period interval
# get "/stocks/:id"
get "/users/:user_id/:sym/:period" do
	# if request.xhr?
		@period = params[:period]
		@current_user = current_user
		@comment = Comment.all
		# if params[:sym] && params[:period]
			@data = Stock.new.data(params[:sym], params[:period].to_i)
			@sym = @data.first.symbol.downcase	#why can't I put this in "action" of the form?!?!
			@stock = Stock.find_by(symbol: params[:sym])
			@plot_data_img = Stock.plot(@sym, @period.to_i)
		# end
		# if request.xhr?
			# erb :show, layout: false
		# else
		erb :show
		# end
	# else
		# redirect "/users/#{params[:user_id]}/#{params[:sym]}/#{params[:period]}"
	# end
end

post "/users/:user_id" do
	user = User.find(params[:user_id])
	if current_user	#is in session
		# login(user)
		params[:period] = 30 if params[:period] == ""
		@comment = Comment.all
		@current_user = current_user
		@stock = Stock.find_by(symbol: params[:symbol])
		@data = Stock.new.data(params[:symbol], params[:period].to_i)

		# checking for a valid symbol in the field
		symbol_field = {sym: params[:symbol], period: params[:period]}
			if dataExist?(symbol_field) #&& request.xhr?
				Stock.create(symbol: symbol_field[:sym])
				# erb :_field, layout: false#, locals: {comment: @comment }, layout: false
				# if 
				# {comment: @comment, stock: @stock, data: @data }
				redirect "/users/#{params[:user_id]}/#{params[:symbol]}/#{params[:period]}"
			else
				@symbol_error = "<p id=\"invalid-sym\">The symbol <span class=\"sym\">#{symbol_field[:sym]}</span> is not valid. Try a different one, e.g. GOOG, YHOO, APPL, etc.</p>"

				erb :show
				# redirect "/users/#{user.id}"
			end	
	else
		redirect "/login"
	end
end

post "/users/:user_id/:sym/:period" do
# post "/users/:user_id/comment" do
# post "stocks/:id/comment" do
# need hidden field in form for the value of the stock
  # @user = User.find_by(id: session[:user_id])
	stock = Stock.find_by(symbol: params[:sym])
	comment = Comment.create(comment: params[:comment], stock_id: stock.id, user_id: params[:user_id])
	user = User.find(comment.user_id)

	if request.xhr?
		{first_name: user.first_name, last_name: user.last_name, comment: comment.comment}.to_json
	else
		redirect "/users/#{params[:user_id]}/#{params[:sym]}/#{params[:period]}"
	end
end
