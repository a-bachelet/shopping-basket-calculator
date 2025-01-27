require_relative './classes/buy_list_reader.rb'
require_relative './classes/receipt_printer.rb'

buy_list_path = ARGV[0]
buy_list = File.read(buy_list_path)
basket = BuyListReader.read(buy_list)

puts ReceiptPrinter.print(basket)
