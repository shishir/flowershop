module FlowerShop
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
      "#{@size} #{product.code} #{cost}"
    end
  end
end