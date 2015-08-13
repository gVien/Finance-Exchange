# require "yahoofinance"
# require 'pp'

class Stock < ActiveRecord::Base
	has_many :comments
  validates :symbol, uniqueness: true

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
          "," + substr
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
# require "mechanize"
# p Stock.get_yahoo_finance_news_for("goog")
