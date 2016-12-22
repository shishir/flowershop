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
    bag = ShoppingBag.new
    bundles = lookup_bundle(code).sort_by {|b| b.size}
    while quantity > 0
      bundles.each do |b|
        if quantity > b.size
          bag.add_item(b, 1)
          quantity =- b.size
        end
      end
    end
  end

  def lookup_bundle(code)
    @bundles.collect do |bundle|
      bundle.has_product?(code)
    end
  end

end

class ShoppingBag

  attr_reader :items

  def initialize
    @items = []
  end

  def add_item(bundle, quantity)
    @items << {bundle => quantity}
  end
end

class ProductTest < Test::Unit::TestCase

  def test_should_initialize_with_cost_and_code
    product = Product.new("Rose", "R12")
    assert_equal "Rose", product.name
    assert_equal "R12", product.code
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
    assert_equal @bundle.size, 5
    assert_equal @bundle.product, @rose
    assert_equal @bundle.cost, 7.99
  end

  def test_should_fetch_product_via_code
    assert @bundle.has_product?("R12")
    assert !@bundle.has_product?("R13")
  end

end

class ShopTest < Test::Unit::TestCase

  def setup
    rose           = Product.new("Rose", "R12")
    @rose_bundle_1 = Bundle.new(5, rose, 7.99)
    @rose_bundle_2 = Bundle.new(10, rose, 12.99)
    @shop = Shop.new([@rose_bundle_1, @rose_bundle_2])
  end

  def test_should_initialize_catalog_with_bundles
    assert_equal @shop.size, 2
  end

  def test_should_look_up_bundles_by_code
    assert_equal @shop.lookup_bundle("R12"), [@rose_bundle_1, @rose_bundle_2]
  end

  def test_sell_same_flowers
    bag = @shop.sell("R10", 15)
    assert_equal bag.items.size, 2
    assert bag.include?(@rose_bundle_2)
    assert bag.include?(@rose_bundle_1)
  end

end