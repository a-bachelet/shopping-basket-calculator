require_relative '../../classes/basket.rb'
require_relative '../../classes/receipt_printer.rb'

describe ReceiptPrinter do
  describe 'self.print' do
    let(:basket) { instance_double(Basket) }

    subject { described_class.print(basket) }

    context "when basket is invalid" do
      [nil, {}].each do |invalid_basket|
        it { expect { subject }. to raise_error(ReceiptPrinter::Error::PRINT_BASKET_TYPE_ERROR) }
      end
    end

    context "when basket is valid" do
      before do
        allow(basket).to receive(:instance_of?).with(Basket).and_return(true)
        
        allow(basket).to receive(:detailed_products_with_taxes).and_return([
          { name: 'Product A', quantity: 43, unit_price: 10, tax_percentage: 23, unit_tax_price: 45, total_tax_price: 890, total_price: 1000.4590 },
          { name: 'Product B', quantity: 30, unit_price: 2, tax_percentage: 3, unit_tax_price: 8, total_tax_price: 9, total_price: 100 },
        ])

        allow(basket).to receive(:total_tax_price).and_return(45.6890)
        allow(basket).to receive(:total_price).and_return(80.9999)
      end

      let(:expected_result) { "43 Product A: 1000.46\n30 Product B: 100.00\nSales Taxes: 45.69\nTotal: 81.00" }

      it { expect(subject).to eq(expected_result) }
    end
  end
end