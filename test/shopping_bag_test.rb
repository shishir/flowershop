require_relative 'test_helper'

module FlowerShop
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
end