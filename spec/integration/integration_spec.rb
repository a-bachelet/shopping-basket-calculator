require_relative '../../classes/buy_list_reader.rb'
require_relative '../../classes/receipt_printer.rb'

describe 'IntegrationTest' do
  it "passes the integration test" do
    input1 = File.read('spec/data/buy_lists/buy_list_1.txt')
    input2 = File.read('spec/data/buy_lists/buy_list_2.txt')
    input3 = File.read('spec/data/buy_lists/buy_list_3.txt')

    expected1 = File.read('spec/data/expected_receipts/expected_receipt_1.txt')
    expected2 = File.read('spec/data/expected_receipts/expected_receipt_2.txt')
    expected3 = File.read('spec/data/expected_receipts/expected_receipt_3.txt')

    expect(ReceiptPrinter.print(BuyListReader.read(input1))).to eq(expected1)
    expect(ReceiptPrinter.print(BuyListReader.read(input2))).to eq(expected2)
    expect(ReceiptPrinter.print(BuyListReader.read(input3))).to eq(expected3)
  end
end