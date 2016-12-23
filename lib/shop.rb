require 'forwardable'
require_relative 'product'
require_relative 'bundle'
require_relative 'shopping_bag'

class Shop
  extend Forwardable

  attr_reader :bundles, :bag

  def_delegator :@bundles, :size

  def initialize(bundles = [])
    @bundles = bundles.empty? ? load_catalog : bundles
    @bag     = ShoppingBag.new
  end

  def sell(code, quantity)
    bundles = lookup_bundle(code).sort {|a,b| a.size <=> b.size}.reverse
    while assign_bundles(bundles, @bag, quantity) == false && bundles.size > 0
      bundles = bundles - [bundles.first]
      @bag.remove_items_by_code(code)
    end
  end

  def lookup_bundle(code)
    @bundles.select do |bundle|
      bundle if bundle.has_product?(code)
    end.compact
  end

  private

  def assign_bundles(bundles, bag, quantity)
    return true if quantity == 0
    return false if quantity > 0 && bundles.empty?

    b = bundles.first

    if quantity >= b.size
      bag.add_item(b)
      assign_bundles(bundles, bag, quantity - b.size)
    else
      assign_bundles(bundles - [b], bag, quantity)
    end
  end

  def load_catalog
    [
      Bundle.new(5  , Product.new("Roses"  , "R12") , 7.99),
      Bundle.new(10 , Product.new("Roses"  , "R12") , 12.99),
      Bundle.new(3  , Product.new("Lilies" , "L09") , 9.95),
      Bundle.new(6  , Product.new("Lilies" , "L09") , 16.95),
      Bundle.new(9  , Product.new("Lilies" , "L09") , 24.95),
      Bundle.new(3  , Product.new("Tulips" , "T58") , 5.95),
      Bundle.new(5  , Product.new("Tulips" , "T58") , 9.95),
      Bundle.new(9  , Product.new("Tulips" , "T58") , 16.95),
    ]
  end

end
