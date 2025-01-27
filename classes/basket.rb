require_relative './product.rb'
require_relative './tax_calculator.rb'

class Basket
  class Error
    ADD_PRODUCT_PRODUCT_TYPE_ERROR = 'Basket#add_product | product must be an instance of ::Product'
    ADD_PRODUCT_QUANTITY_ERROR = 'Basket#add_product | quantity must be a positive integer'
  end

  attr_reader :products

  def initialize
    @products = {}
  end

  def add_product(product, quantity = 1)
    raise Error::ADD_PRODUCT_PRODUCT_TYPE_ERROR unless product.instance_of? Product
    raise Error::ADD_PRODUCT_QUANTITY_ERROR unless quantity.to_i.positive?

    products[product] = quantity.to_i
  end

  def detailed_products_with_taxes
    products.map do |product, quantity|
      name = product.name
      unit_price = product.price
      tax_percentage = product.tax_percentage
      
      unit_tax_price = TaxCalculator.tax_price(unit_price, tax_percentage)
      total_tax_price = unit_tax_price * quantity

      total_price = unit_price * quantity + total_tax_price

      { name:, quantity:, unit_price:, tax_percentage:, unit_tax_price:, total_tax_price:, total_price: }
    end
  end

  def total_tax_price
    unrounded_result = detailed_products_with_taxes.inject(0) { |sum, product| sum + product[:total_tax_price] }
    (unrounded_result * 100).round / 100.0
  end

  def total_price
    unrounded_result = detailed_products_with_taxes.inject(0) { |sum, product| sum + product[:total_price] }
    (unrounded_result * 100).round / 100.0
  end
end
