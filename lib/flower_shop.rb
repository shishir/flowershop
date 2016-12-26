require 'forwardable'
require_relative 'flower_shop/product'
require_relative 'flower_shop/bundle'
require_relative 'flower_shop/shopping_bag'
require_relative 'flower_shop/shop'

module FlowerShop
  def self.handle_customer
    $/ = "\n\n"

    shop = Shop.new
    input = gets

    rows = input.split("\n")
    rows.each do |row|
     quantity, code = row.split(' ')
     shop.sell(code, quantity.to_i)
    end
    puts shop.bag.to_s
  end
end

FlowerShop.handle_customer