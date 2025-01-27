require_relative '../../classes/tax_calculator.rb'

describe TaxCalculator do
  describe '#self.round_up' do
    subject { described_class.round_up(tax_price) }

    [
      { tax_price: 5, expected_round_up: 5 },
      { tax_price: 0.5215, expected_round_up: 0.55 },
      { tax_price: 0.5625, expected_round_up: 0.6 },
    ].each do |test_values|
      context "when tax_price is #{test_values[:tax_price]}" do
        let(:tax_price) { test_values[:tax_price] }

        it "rounds up to #{test_values[:expected_round_up]}" do
          expect(subject).to eq(test_values[:expected_round_up])
        end
      end
    end

    context "when tax_price is invalid" do
      [nil, '', 0, -1.2].each do |invalid_tax_price|
        let(:tax_price) { invalid_tax_price }

        it "raises an error" do
          expect { subject }.to raise_error(TaxCalculator::Error::TAX_CALCULATOR_ROUND_UP_TAX_PRICE_ERROR)
        end
      end
    end
  end

  describe '#self.tax_price' do
    subject { described_class.tax_price(shelf_price, tax_percentage) }

    [
      { shelf_price: 11.25, tax_percentage: 5, expected_tax_price: 0.6 },
      { shelf_price: 18.99, tax_percentage: 10, expected_tax_price: 1.9 },
      { shelf_price: 25, tax_percentage: 0, expected_tax_price: 0 },
    ].each do |test_values|
      context "when shelf_price is #{test_values[:shelf_price]} and tax_percentage is #{test_values[:tax_percentage]}" do
        let(:shelf_price) { test_values[:shelf_price] }
        let(:tax_percentage) { test_values[:tax_percentage] }

        it "calculates a tax price of #{test_values[:expected_tax_price]}" do
          expect(subject).to eq(test_values[:expected_tax_price])
        end
      end
    end

    context "when shelf_price is invalid" do
      [nil, '', 0, -1.2].each do |invalid_shelf_price|
        let(:shelf_price) { invalid_shelf_price }
        let(:tax_percentage) { 10 }

        it "raises an error" do
          expect { subject }.to raise_error(TaxCalculator::Error::TAX_CALCULATOR_TAX_PRICE_SHELF_PRICE_ERROR)
        end
      end
    end

    context "when tax_percentage is invalid" do
      [nil, '', -1.2].each do |invalid_tax_percentage|
        let(:shelf_price) { 10 }
        let(:tax_percentage) { invalid_tax_percentage }

        it "raises an error" do
          expect { subject }.to raise_error(TaxCalculator::Error::TAX_CALCULATOR_TAX_PRICE_TAX_PERCENTAGE_ERROR)
        end
      end
    end
  end
end
