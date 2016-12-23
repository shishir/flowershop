require_relative 'test_helper'

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
