require_relative '../../classes/product.rb'

describe Product do
  describe "#initialize" do
    let(:name) { 'A product' }
    let(:price) { 10 }

    subject { described_class.new(name, price) }

    it { expect(subject).to be_an_instance_of(Product) }

    context "when name is invalid" do
      [nil, ''].each do |invalid_name|
        let(:name) { invalid_name }

        it "raises an error" do
          expect { subject }.to raise_error(Product::Error::INITIALIZE_NAME_ERROR)
        end
      end
    end

    context "when price is invalid" do
      [nil, '', 0, -12.5].each do |invalid_price|
        let(:price) { invalid_price }
        
        it "raises an error" do
          expect { subject }.to raise_error(Product::Error::INITIALIZE_PRICE_ERROR)
        end
      end
    end

    context "when name is valid" do
      it "takes the name" do
        expect(subject.name).to eq(name)
      end
    end

    context "when price is valid" do
      it "takes the price" do
        expect(subject.price).to eq(price)
      end
    end
  end

  describe "#category" do
    let(:price) { 10 }

    subject { described_class.new(name, price).category }

    context "when it's a book" do
      ["book", "novel", "magazine", "journal"].each do |book_keyword|
        let(:name) { book_keyword }

        it { expect(subject).to eq(:book) }
      end
    end

    context "when it's food" do
      ["chocolate", "bread", "milk", "cheese", "fruit"].each do |food_keyword|
        let(:name) { food_keyword }

        it { expect(subject).to eq(:food) }
      end
    end

    context "when it's a medicine" do
      ["pill", "syrup", "ointment", "medicine", "bandage"].each do |medicine_keyword|
        let(:name) { medicine_keyword }

        it { expect(subject).to eq(:medicine) }
      end
    end
  end

  describe "#is_taxable" do
    let(:name) { 'A product' }
    let(:price) { 10 }
    let(:product) { described_class.new(name, price) }
    let(:category) { :unknown }

    subject { product.is_taxable }

    before do
      allow(product).to receive(:category).and_return(category)
      allow(product).to receive(:is_taxable).and_call_original
    end

    non_taxable_categories = [:book, :food, :medicine]

    context "when category is non taxable" do
      non_taxable_categories.each do |category|
        let(:category) { category }

        it { expect(subject).to be_falsy }
      end
    end

    context "when category is taxable" do
      it { expect(subject).to be_truthy }
    end
  end

  describe "#is_imported" do
    let(:price) { 10 }

    subject { described_class.new(name, price).is_imported }

    context "when it is not imported" do
      let(:name) { 'A standard product' }

      it { expect(subject).to be_falsy }
    end

    context "when it is imported" do
      ['Some import', 'Some imported product'].each do |product_name|
        let(:name) { product_name }

        it { expect(subject).to be_truthy }
      end
    end
  end

  describe "#tax_percentage" do
    let(:name) { 'A product' }
    let(:price) { 10 }
    let(:product) { described_class.new(name, price) }
    let(:category) { :unknown }

    subject { product.tax_percentage }

    before do
      allow_any_instance_of(described_class).to receive(:is_taxable).and_return(is_taxable)
      allow_any_instance_of(described_class).to receive(:is_imported).and_return(is_imported)
    end

    context "when product is taxable and is imported" do
      let(:is_taxable) { true }
      let(:is_imported) { true }

      it { expect(subject).to eq(15) }
    end

    context "when product is taxable and is not imported" do
      let(:is_taxable) { true }
      let(:is_imported) { false }

      it { expect(subject).to eq(10) }
    end

    context "when product is imported and is not taxable" do
      let(:is_taxable) { false }
      let(:is_imported) { true }

      it { expect(subject).to eq(5) }
    end

    context "when product is not taxable and is not imported" do
      let(:is_taxable) { false }
      let(:is_imported) { false }

      it { expect(subject).to eq(0) }
    end
  end
end
