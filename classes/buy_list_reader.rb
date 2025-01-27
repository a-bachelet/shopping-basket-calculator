require_relative './basket.rb'
require_relative './product.rb'

class BuyListReader
  class Error
    READ_BUY_LIST_TYPE_ERROR = "BuyListReader#self.read | buy_list must be a string"
    READ_BUY_LIST_FORMAT_ERROR = "BuyListReader#self.read | buy_list must match the expected format"
  end

  BUY_LIST_FORMAT_REGEX = /^(\d+)\s+(.+?)\s+at\s+(\d+\.\d{2})$/

  def self.read(buy_list)
    raise Error::READ_BUY_LIST_TYPE_ERROR unless buy_list.is_a? String

    buy_lines = buy_list.split("\n")

    raise Error::READ_BUY_LIST_FORMAT_ERROR if buy_lines.any? { _1.match(BUY_LIST_FORMAT_REGEX).nil? }

    basket = Basket.new

    buy_lines.each do |buy_line|
      matched_data = buy_line.match(BUY_LIST_FORMAT_REGEX)

      quantity = matched_data[1].to_f
      name = matched_data[2]
      price = matched_data [3].to_f

      basket.add_product(Product.new(name, price), quantity)
    end

    basket
  end
end