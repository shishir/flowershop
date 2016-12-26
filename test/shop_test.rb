require_relative 'test_helper'

module FlowerShop
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
end