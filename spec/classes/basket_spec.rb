require_relative '../../classes/basket.rb'
require_relative '../../classes/product.rb'
require_relative '../../classes/tax_calculator.rb'

describe Basket do
  describe "#initialize" do
    subject { described_class.new }

    it { expect(subject).to be_an_instance_of(Basket) }
    it { expect(subject.products).to be_an_instance_of(Hash) }
    it { expect(subject.products.keys).to be_empty }
  end

  describe "#add_product" do
    let(:product) { Product.new('A product', 10) }
    let(:quantity) { 100 }
    let(:basket) { described_class.new }

    subject { basket.add_product(product, quantity) }

    describe "when adding something that is not a ::Product instance" do
      [nil, { name: 'A product', price: 10 }].each do |invalid_product|
        let(:product) { invalid_product }

        it { expect { subject }.to raise_error(Basket::Error::ADD_PRODUCT_PRODUCT_TYPE_ERROR) }
      end

      
    end

    describe "when adding an invalid quantity of products" do
      [-30.4, 0, nil, ''].each do |invalid_quantity|
        let(:quantity) { invalid_quantity }

        it { expect { subject }.to raise_error(Basket::Error::ADD_PRODUCT_QUANTITY_ERROR) }
      end
    end

    describe "when adding a valid quantity of a valid product" do
      before { subject }

      it { expect(basket.products.keys).not_to be_empty }
      it { expect(basket.products.keys).to include(product) }
      it { expect(basket.products[product]).to eq(quantity) }
    end
  end

  describe "#detailed_products_with_taxes" do
    let(:basket) { described_class.new }

    before do
      basket.add_product(Product.new('First product', 10), 10)
      basket.add_product(Product.new('Second product', 20), 2)
      basket.add_product(Product.new('Third product', 14.99), 8)

      allow(TaxCalculator).to receive(:tax_price).and_return 10
    end

    subject { basket.detailed_products_with_taxes }

    let(:expected_result) do
      [
        { name: 'First product', quantity: 10, unit_price: 10, tax_percentage: 10, unit_tax_price: 10, total_tax_price: 100, total_price: 200},
        { name: 'Second product', quantity: 2, unit_price: 20, tax_percentage: 10, unit_tax_price: 10, total_tax_price: 20, total_price: 60},
        { name: 'Third product', quantity: 8, unit_price: 14.99, tax_percentage: 10, unit_tax_price: 10, :total_tax_price=>80, total_price: 199.92000000000002  }
      ]
    end

    it { expect(subject).to eq(expected_result) }
  end

  describe "#total_tax_price" do
    let(:basket) { described_class.new }

    before do
      basket.add_product(Product.new('First product', 10), 10)
      basket.add_product(Product.new('Second product', 20), 2)
      basket.add_product(Product.new('Third product', 14.99), 8)

      allow(TaxCalculator).to receive(:tax_price).and_return 10
    end

    subject { basket.total_tax_price }

    it { expect(subject).to eq(200) }
  end

  describe "#total_price" do
    let(:basket) { described_class.new }

    before do
      basket.add_product(Product.new('First product', 10), 10)
      basket.add_product(Product.new('Second product', 20), 2)
      basket.add_product(Product.new('Third product', 14.99), 8)

      allow(TaxCalculator).to receive(:tax_price).and_return 10
    end

    subject { basket.total_price }

    it { expect(subject).to eq(459.92) }
  end
end
