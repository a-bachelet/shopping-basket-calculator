class TaxCalculator
  class Error
    TAX_CALCULATOR_ROUND_UP_TAX_PRICE_ERROR = 'TaxCalculator#self.round_up | tax_price must be a positive number or 0'
    TAX_CALCULATOR_TAX_PRICE_SHELF_PRICE_ERROR = 'TaxCalculator#self.tax_price | shel_price must be a positive number'
    TAX_CALCULATOR_TAX_PRICE_TAX_PERCENTAGE_ERROR = 'TaxCalculator#self.tax_price | tax_percentage must be a positive number or 0'
  end

  def self.round_up(tax_price)
    raise Error::TAX_CALCULATOR_ROUND_UP_TAX_PRICE_ERROR unless tax_price&.positive? || tax_price&.zero?

    ((tax_price * 20).ceil / 20.0).round(2)
  end

  def self.tax_price(shelf_price, tax_percentage)
    raise Error::TAX_CALCULATOR_TAX_PRICE_SHELF_PRICE_ERROR unless shelf_price&.positive?
    raise Error::TAX_CALCULATOR_TAX_PRICE_TAX_PERCENTAGE_ERROR unless tax_percentage&.positive? || tax_percentage&.zero?
    
    raw_tax = (shelf_price * tax_percentage / 100.0)
    self.round_up(raw_tax)
  end
end