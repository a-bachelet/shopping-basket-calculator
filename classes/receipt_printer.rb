require_relative './basket.rb'

class ReceiptPrinter
  class Error
    PRINT_BASKET_TYPE_ERROR = 'ReceiptPrinter#initialize | basket must be an instance of ::Basket'
  end

  def self.print(basket)
    raise Error::PRINT_BASKET_TYPE_ERROR unless basket.instance_of? Basket

    output = ''

    basket.detailed_products_with_taxes.each do |details|
      output << "#{details[:quantity]} #{details[:name]}: #{sprintf('%.2f', details[:total_price].round(2))}\n"
    end

    output << "Sales Taxes: #{sprintf('%.2f', basket.total_tax_price.round(2))}\n"
    output << "Total: #{sprintf('%.2f', basket.total_price.round(2))}"

    output
  end
end