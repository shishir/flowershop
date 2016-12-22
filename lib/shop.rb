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

end

class Bundle

  attr_reader :size, :product, :cost

  def initialize(size, product, cost)
    @size    = size
    @product = product
    @cost    = cost
  end

  def has_product?(code)
    product.with_code?(code)
  end

end

class Shop

  def initialize(bundles)
    @bundles = bundles
  end

  def size
    @bundles.size
  end

  def sell(code, quantity)
    bag     = ShoppingBag.new
    bundles = lookup_bundle(code).sort {|a,b| a.size <=> b.size}.reverse
    bundles.each do |b|
      no_of_bundles = 0
      while quantity >= b.size
        no_of_bundles += 1
        quantity      -= b.size
      end
      bag.add_item b, no_of_bundles
    end
    bag
  end

  def lookup_bundle(code)
    @bundles.select do |bundle|
      bundle if bundle.has_product?(code)
    end.compact
  end

end

class ShoppingBag
  attr_reader :items

  def initialize
    @items = {}
  end

  def add_item(bundle, quantity)
    @items[bundle] = quantity + (@items[bundle] || 0)
  end

  def quantity_for(item)
     @items[item]
  end

  def include?(item)
    @items.keys.include?(item)
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

end

class ShoppingBagTest < Test::Unit::TestCase

  def setup
    @bag = ShoppingBag.new
  end

  def test_should_add_items
    @bag.add_item(1, 20)

    assert @bag.include?(1)
  end

  def test_should_increment_quantity_if_item_already_exists
    @bag.add_item(1, 20)
    @bag.add_item(1, 30)

    assert_equal 50, @bag.quantity_for(1)
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
    bag = @shop.sell("R12", 15)
    assert_equal bag.items.size, 2
    assert bag.include?(@rose_bundle_2), "bundle not found"
    assert bag.include?(@rose_bundle_1), "bundle not found"
  end

end