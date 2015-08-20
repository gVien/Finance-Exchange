

# get stock symbol information with specific period interval
# get "/stocks/:id"
get "/stocks" do
	if current_user
		erb :show
	else
		redirect "/login"
	end
end

get "/stocks/:sym/period/:period" do
		@comment = Comment.all
		@data = YahooFinanceDataCollector.get_price_data(params[:sym], params[:period].to_i)
		@sym = @data.first.symbol.downcase	#why can't I put this in "action" of the form?!?!
		@stock = Stock.find_by(symbol: params[:sym])

		erb :show
end

post "/stocks" do
	if current_user
		params[:period] = 30 if params[:period] == ""


		# checking for a valid symbol in the field
		symbol_field = {sym: params[:symbol].upcase, period: params[:period]}
		render_page_with_stock_info(symbol_field)
	else
		redirect "/login"
	end
end

post "/stocks/:sym/period/:period" do
	@stock = Stock.find_by(symbol: params[:sym])
	@period = params[:period]
	@comment = Comment.create(comment: params[:comment], stock_id: @stock.id, user_id: current_user.id)
	user = User.find(@comment.user_id)

	if request.xhr?
		{first_name: user.first_name, last_name: user.last_name, comment: @comment.comment}.to_json
	else
		redirect "stocks/#{params[:sym]}/period/#{@period}"
	end
end
