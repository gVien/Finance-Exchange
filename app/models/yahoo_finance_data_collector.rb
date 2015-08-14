class YahooFinanceDataCollector

  def self.get_price_data(stock_symbol, days)
    self.new.get_price_data(stock_symbol, days)
  end

  def get_price_data(stock_symbol, days)
    # the data will be in the format of
    # [day1Object, day2Object, ...]
    # where each object contains date, open, close,
    arr_of_hash_data = []
    YahooFinance::get_HistoricalQuotes_days(stock_symbol,days) do |day_data|
      arr_of_hash_data << day_data
    end
    # arr_of_hash_data.length > 0 ? arr_of_hash_data : "not valid"
    arr_of_hash_data
  end


  def self.parse_yahoo_finance_price_data(sym)
    mechanize = Mechanize.new
    url = "http://finance.yahoo.com/q?s=" + sym
    page = mechanize.get(url)
  end

  # A quick reference to the Yahoo Finance news for the stock symbol
  # to get link, perform another search with anchor element
  # example: get_yahoo_finance_news_for("yhoo").search("a")["href"] which returns an array of anchors
  # the anchor arrays accepts the following attributes
  # ["href"] => href link
  # .inner_text => The Title of the news article, cmd is same as innerHTML
  # ["data-ylk"] => which is the news source

  # The complete .inner_text of `get_yahoo_finance_news_for(sym)` returns title, source, and date
  def self.get_yahoo_finance_news_for(sym)
    parse_yahoo_finance_price_data(sym).search("#yfi_headlines .bd li").map {|data| data}
  end

  def self.news_data_for(sym)
    news_source_arr = []
    get_yahoo_finance_news_for(sym).each_with_index do |li, i|
      anchor_element = li.search("a").first
      # http://stackoverflow.com/questions/10799136/get-text-directly-inside-a-tag-in-nokogiri
      publisher = li.search("cite").xpath("text()").first.inner_text  #xpath gets the element text only, ignores other tag inside it
      published_date = li.search("cite > span").inner_text
      news_source_arr << {title: anchor_element.inner_text, href: anchor_element["href"], publisher: publisher, published_date: published_date}
    end
    news_source_arr
  end

  def self.company_name(sym)
    parse_yahoo_finance_price_data(sym).search(".title h2").inner_text
  end

end

# pp q = YahooFinanceDataCollector.get_price_data("GOOG", 15)
# p q.first.symbol.kind_of? String
# p Stock.plot("NEW",45)
# require "mechanize"
# p g = YahooFinanceDataCollector.company_name("goog")
# g.each do |title|
# p title[:title]
# end

