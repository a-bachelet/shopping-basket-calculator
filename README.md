# Shopping Basket Calculator

This project calculates the total cost of a shopping basket, including taxes, based on a provided text file with a list of items, prices and quantities.

## Prerequisites

To run this project, you need :
- Ruby installed on your system
- The `rspec` gem installed globally for testing:
```bash
gem install rspec
```

Alternatively, you can use docker to get this environement setup automatically for you :

```bash
docker build -t basket-calculator .
docker run -d --name basket-calculator -v ./:/root basket-calculator
docker exec -it basket-calculator bash
cd /root
ruby script.rb ./buy_list.txt
```

Finally, you can use the Devcontainer configuration directly from your editor.

## Run the tests

To run the tests, run the following command :
```bash
rspec
```

This will run all the tests located under the `spec` folder.

## How to use it ?
Once you are in a setup environment, you can update the file called `buy_list.txt` and call the script like this :
```bash
ruby script.rb ./buy_list.txt
```

By default, the ouput result will be :
```txt
2 book: 24.98
1 music CD: 16.49
1 chocolate bar: 0.85
Sales Taxes: 1.50
Total: 42.32
```