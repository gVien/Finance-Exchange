class YahooFinanceDataCollector
  # attr_access :days

  # def initialize(days)
  #   @days = days
  # end

  def self.run(stock_symbol, days)
    self.new.run(stock_symbol, days)
  end

  def run(stock_symbol, days)
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

end
