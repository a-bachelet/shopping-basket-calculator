class Product
  class Error
    INITIALIZE_NAME_ERROR = 'Product#initialize | name must be a non empty string'
    INITIALIZE_PRICE_ERROR = 'Product#initialize | price must be a positive number'
  end

  BASIC_TAX_PERCENTAGE = 10 # All goods, except books, food, medical products
  IMPORT_TAX_PERCENTAGE = 5 # No exemptions

  NON_TAXABLE_CATEGORIES_MAPPING = {
    book: ["book", "novel", "magazine", "journal"],
    food: ["chocolate", "bread", "milk", "cheese", "fruit"],
    medicine: ["pill", "syrup", "ointment", "medicine", "bandage"]
  }

  IMPORT_KEYWORD = 'import'

  attr_reader :name, :price, :tax_percentage

  def initialize(name, price)
    raise Error::INITIALIZE_NAME_ERROR unless !name&.to_s.empty?
    raise Error::INITIALIZE_PRICE_ERROR unless price&.positive?

    @name = name
    @price = price
    @tax_percentage = calculate_tax_percentage
  end

  def category
    NON_TAXABLE_CATEGORIES_MAPPING.each do |category, keywords|
      keywords.each do |keyword|
        return category if name.downcase.include?(keyword)
      end
    end

    :unknown
  end

  def is_taxable
    !NON_TAXABLE_CATEGORIES_MAPPING.keys.include?(category)
  end

  def is_imported
    name.downcase.include?(IMPORT_KEYWORD)
  end

  private

  def calculate_tax_percentage
    return BASIC_TAX_PERCENTAGE + IMPORT_TAX_PERCENTAGE if is_taxable && is_imported
    return BASIC_TAX_PERCENTAGE if is_taxable
    return IMPORT_TAX_PERCENTAGE if is_imported
    0
  end
end
