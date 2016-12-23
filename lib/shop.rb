require 'forwardable'
require 'test/unit'

class Product

  attr_reader :name, :code

  def initialize(name, code)
    @name = name
    @code = code
  end

  def with_code?(code)
    @code == code
  end

  def == (other)
    @name == other.name && @code == other.code
  end

  alias eql? ==

  def hash
    @name.hash ^ @code.hash
  end
end

class Bundle
  extend Forwardable

  attr_reader :size, :product, :cost

  def_delegator :@product, :code

  def initialize(size, product, cost)
    @size    = size
    @product = product
    @cost    = cost
  end

  def has_product?(code)
    product.with_code?(code)
  end

  def ==(other)
    product == other.product && size == other.size && cost == other.cost
  end

  alias eql? ==

  def hash
    @product.hash ^ @size.hash ^ @cost.hash
  end

  def to_s
    "#{product.code}-#{@size}"
  end

end

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

class ShoppingBag
  attr_reader :items

  def initialize
    @items = {}
  end

  def add_item(bundle)
    @items[bundle] = 1 + (@items[bundle] || 0)
  end

  def quantity_for(item)
    @items[item] || 0
  end

  def remove_items_by_code(code)
    @items.reject! {|i| i.code == code}
  end

  def include?(item)
    @items.keys.include?(item)
  end

  def to_s
    @items.inject("") do |str, item|
      str += item.to_s + " "
      str
    end
  end
end

class ProductTest < Test::Unit::TestCase

  def test_should_initialize_with_cost_and_code
    product = Product.new("Rose", "R12")

    assert_equal "Rose", product.name
    assert_equal "R12" , product.code
  end

  def test_should_return_true_if_code_is_corrrect
    product = Product.new("Rose", "R12")

    assert product.with_code?("R12")
  end

end

class BundleTest < Test::Unit::TestCase

  def setup
    @rose   = Product.new("Rose", "R12")
    @bundle = Bundle.new(5, @rose, 7.99)
  end

  def test_should_initialize_with_correct_parameters
    assert_equal 5     , @bundle.size
    assert_equal @rose , @bundle.product
    assert_equal 7.99  , @bundle.cost
  end

  def test_should_fetch_product_via_code
    assert  @bundle.has_product?("R12")
    assert !@bundle.has_product?("R13")
  end

  def test_equality
    assert_equal Bundle.new(10 , Product.new("Roses"  , "R12") , 12.99), Bundle.new(10 , Product.new("Roses"  , "R12") , 12.99)
    assert_equal Bundle.new(10 , Product.new("Roses"  , "R12") , 12.99).hash, Bundle.new(10 , Product.new("Roses"  , "R12") , 12.99).hash
  end

end

class ShoppingBagTest < Test::Unit::TestCase

  def setup
    @bag = ShoppingBag.new
  end

  def test_should_add_items
    @bag.add_item(1)

    assert @bag.include?(1)
  end

  def test_should_increment_quantity_if_item_already_exists
    @bag.add_item(1)
    @bag.add_item(1)

    assert_equal 2, @bag.quantity_for(1)
  end

  def test_should_able_to_tell_quantity_for_an_item
    @bag.add_item(Bundle.new(10 , Product.new("Roses"  , "R12") , 12.99))
    assert_equal 1, @bag.quantity_for(Bundle.new(10 , Product.new("Roses"  , "R12") , 12.99))
  end

  def test_remove_items
    @bag.add_item(Bundle.new(10 , Product.new("Roses"  , "R12") , 12.99))
    @bag.add_item(Bundle.new(4 , Product.new("Roses"  , "R12") , 12.99))
    assert_equal 1, @bag.quantity_for(Bundle.new(10 , Product.new("Roses"  , "R12") , 12.99))
    assert_equal 1, @bag.quantity_for(Bundle.new(4 , Product.new("Roses"  , "R12") , 12.99))

    @bag.remove_items_by_code("R12")

    assert_equal 0, @bag.quantity_for(Bundle.new(10 , Product.new("Roses"  , "R12") , 12.99))
    assert_equal 0, @bag.quantity_for(Bundle.new(4 , Product.new("Roses"  , "R12") , 12.99))
  end

end

class ShopTest < Test::Unit::TestCase

  def setup
    rose           = Product.new("Rose", "R12")
    @rose_bundle_1 = Bundle.new(5, rose, 7.99)
    @rose_bundle_2 = Bundle.new(10, rose, 12.99)
    @shop          = Shop.new([@rose_bundle_1, @rose_bundle_2])
  end

  def test_should_initialize_catalog_with_bundles
    assert_equal 2, @shop.size
  end

  def test_should_look_up_bundles_by_code
    assert_equal [@rose_bundle_1, @rose_bundle_2], @shop.lookup_bundle("R12")
    assert_equal [], @shop.lookup_bundle("R13")
  end

  def test_sell_same_flowers
    @shop.sell("R12", 15)
    bag = @shop.bag
    assert_equal bag.items.size, 2
    assert bag.include?(@rose_bundle_2), "bundle not found"
    assert bag.include?(@rose_bundle_1), "bundle not found"
  end

  def test_shop_should_initialize_with_the_available_inventory
    shop = Shop.new
    assert !shop.bundles.empty?, "Shop should be initialized with pre-defined catalog"
    assert_equal 8, shop.bundles.size
  end

  def test_shop_to_sell_multiple_items
    shop = Shop.new
    shop.sell("R12", 10)
    shop.sell("L09", 15)
    shop.sell("T58", 13)

    bag = shop.bag

    assert bag.include?(Bundle.new(10 , Product.new("Roses"  , "R12") , 12.99)), "should contain 10x1 bundle roses"
    assert_equal 1, bag.quantity_for(Bundle.new(10 , Product.new("Roses"  , "R12") , 12.99))

    assert bag.include?(Bundle.new(9  , Product.new("Lilies"  , "L09") , 24.95)), "should contain 9x1 bundle lilies"
    assert_equal 1, bag.quantity_for(Bundle.new(9  , Product.new("Lilies"  , "L09") , 24.95))

    assert bag.include?(Bundle.new(6  , Product.new("Lilies"  , "L09") , 16.95))
    assert_equal 1, bag.quantity_for(Bundle.new(6  , Product.new("Lilies"  , "L09") , 16.95))

    assert bag.include?(Bundle.new(5  , Product.new("Tulips"  , "T58") , 9.95)), "should contain 5x2 bundle tulips"
    assert_equal 2, bag.quantity_for(Bundle.new(5  , Product.new("Tulips"  , "T58") , 9.95))

    assert bag.include?(Bundle.new(3  , Product.new("Tulips"  , "T58") , 5.95))
    assert_equal 1, bag.quantity_for(Bundle.new(3  , Product.new("Tulips"  , "T58") , 5.95))

  end

end