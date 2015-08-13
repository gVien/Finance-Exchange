class YahooFinanceDataCollector
  # attr_access :days

  # def initialize(days)
  #   @days = days
  # end

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


  def self.parse_yahoo_finance(sym)
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
    parse_yahoo_finance(sym).search("#yfi_headlines .bd li").map {|data| data}
  end

  def self.get_yahoo_finance_news_anchor_for(sym)
    news_source_arr = []
    get_yahoo_finance_news_for(sym).each_with_index do |li, i|
      p li#[i].search("a").first
      # news_source_arr << [anchor["href"], anchor.inner_text]
    end
    news_source_arr
  end

  def self.get_yahoo_finance_news
  end

  def self.complete_news_url(sym)
  end

  def self.parseGoogleFinance(sym)
  end
end
