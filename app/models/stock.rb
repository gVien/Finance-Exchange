# require "yahoofinance"
# require 'pp'

class Stock < ActiveRecord::Base
	has_many :comments
  validates :symbol, uniqueness: true

	def data(sym, days = 30)
		# the data will be in the format of
		# [day1Object, day2Object, ...]
		# where each object contains date, open, close,
		arr_of_hash_data = []
		YahooFinance::get_HistoricalQuotes_days(sym,days) do |day_data|
			arr_of_hash_data << day_data
		end
		# arr_of_hash_data.length > 0 ? arr_of_hash_data : "not valid"
    arr_of_hash_data
	end


	def self.plot(sym, period)
    # until I find a way to plot the data, this is a good hack
    # to get the plots based on the data
    if period > 30
      month = period / 30
      day = period % 30
    else
      day = period
      month = 0
    end
    "http://stockcharts.com/c-sc/sc?s=" + sym + "&p=D&yr=0&mn=" + month.to_s + "&dy=" + day.to_s + "&i=p67675205728&r=1438664699056"
	end

	# my code from phase 0
	def self.separate_comma(num)
    # 1. Convert the number to string and then array and reverse it
    return num.to_s if num.to_s.length<4
    num = num.to_s.reverse.split("")

    # 2. Define a new number string concatenate the comma separator
    new_num = ""

    # 3. Iterate over the number
    num.each_with_index do |substr,index|
        new_num << if index % 3 == 0 && index != 0 
          ","+substr
          else
            substr
          end
    end
    return new_num.reverse
end

end

# stock = Stock.new
# pp q = stock.data("GOOG", 15)
# p q.first.symbol.kind_of? String
# p Stock.plot("NEW",45)
