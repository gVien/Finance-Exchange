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
		YahooFinanceDataCollector.run(symbol_field[:sym], symbol_field[:period].to_i).length > 0
	end

	def render_page_with_stock_info(symbol_field)
		if dataExist?(symbol_field) && request.xhr?
			@comment = Comment.all
			@data = YahooFinanceDataCollector.run(symbol_field[:sym], symbol_field[:period].to_i)
			@stock = Stock.find_or_create_by(symbol: symbol_field[:sym])
			erb :_field, layout: false
		elsif !dataExist?(symbol_field) && request.xhr?
			@symbol_error = "<p id=\"invalid-sym\">The symbol <span class=\"sym\">#{symbol_field[:sym]}</span> is not valid. Try a different one, e.g. GOOG, YHOO, APPL, etc.</p>"
			# erb :"_invalid-symbol", layouot: false	#no need for this, since it adds it in the body for no reasons
			content_type :json
			{symbol_error: @symbol_error}.to_json
		else
			redirect "/stocks/#{symbol_field[:sym]}/period/#{symbol_field[:period]}"	#/users/#{params[:user_id]}/#{params[:symbol]}/#{params[:period]}"
		end
	end
end
