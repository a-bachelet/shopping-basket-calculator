require_relative '../../classes/buy_list_reader.rb'
require_relative '../../classes/product.rb'

describe BuyListReader do
  describe '#self.read' do
    let(:buy_list) { "9 book at 3.99\n2 boxes of chocolates at 4.55\n7 imported pack of headache pills at 9.99" }

    subject { described_class.read(buy_list) }

    context "when buy_list is valid" do
      it "does not raise an error" do
        expect { subject }.not_to raise_error
      end

      it "returns a basket containing products with quantities" do
        expect(subject).to be_an_instance_of(Basket)

        products = subject.products.keys
        quantities = subject.products.values

        expect(subject.products.length).to eq(3)

        expect(products[0].name).to eq('book')
        expect(products[1].name).to eq('boxes of chocolates')
        expect(products[2].name).to eq('imported pack of headache pills')

        expect(products[0].price).to eq(3.99)
        expect(products[1].price).to eq(4.55)
        expect(products[2].price).to eq(9.99)

        expect(quantities[0]).to eq(9)
        expect(quantities[1]).to eq(2)
        expect(quantities[2]).to eq(7)
      end
    end
    

    context "when buy_list is not a String" do
      [nil, 1.2, {}].each do |invalid_buy_list|
        let(:buy_list) { invalid_buy_list }

        it { expect { subject }.to raise_error(BuyListReader::Error::READ_BUY_LIST_TYPE_ERROR) }
      end
    end

    context "when buy_list has a wrong format" do
      ['', 'boxes of 45 chocolates for 6.78 total/n3 bottles of perfume at 8.99'].each do |invalid_buy_list|
        let(:buy_list) { invalid_buy_list }

        it { expect { subject }.to raise_error(BuyListReader::Error::READ_BUY_LIST_FORMAT_ERROR) }
      end
    end
  end
end
