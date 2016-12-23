require_relative 'test_helper'

module FlowerShop
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
end
