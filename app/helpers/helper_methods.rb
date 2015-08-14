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
		YahooFinanceDataCollector.get_price_data(symbol_field[:sym], symbol_field[:period].to_i).length > 0
	end

	def render_page_with_stock_info(symbol_field)
		if dataExist?(symbol_field) && request.xhr?
			@comment = Comment.all
			@data = YahooFinanceDataCollector.get_price_data(symbol_field[:sym], symbol_field[:period].to_i)
			@stock = Stock.find_or_create_by(symbol: symbol_field[:sym])
			company_news_and_profile
			erb :_field, layout: false
		elsif !dataExist?(symbol_field) && request.xhr?
			@symbol_error = "<p id=\"invalid-sym\">The symbol <span class=\"sym\">#{symbol_field[:sym]}</span> is not valid. Try a different one, e.g. GOOG, YHOO, AAPL, etc.</p>"
			# erb :"_invalid-symbol", layouot: false	#no need for this, since it adds it in the body for no reasons
			content_type :json
			{symbol_error: @symbol_error}.to_json
		else
			redirect "/stocks/#{params[:symbol]}/period/#{params[:period]}"	#/users/#{params[:user_id]}/#{params[:symbol]}/#{params[:period]}"
		end
	end

	def company_news_and_profile
		@news = YahooFinanceDataCollector.news_data_for(params[:symbol])
		@company_profile = GoogleFinanceDataCollector.create_company_profile(params[:symbol])
	end
end
