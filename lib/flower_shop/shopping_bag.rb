module FlowerShop
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
end