module FlowerShop
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
end