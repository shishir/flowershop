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

    def total_cost_by_code(code)
      @items.keys.inject(0) {|total_cost, item| total_cost += item.cost * @items[item] if item.code == code; total_cost}
    end

    def total_quantity_by_code(code)
      @items.keys.inject(0) {|qty, item| qty +=  item.size * quantity_for(item) if item.code == code; qty}
    end

    def items_by_code(code)
      @items.keys.collect {|item| item if item.code == code}.compact
    end

    def remove_items_by_code(code)
      @items.reject! {|i| i.code == code}
    end

    def include?(item)
      @items.keys.include?(item)
    end

    def to_s
      codes = @items.keys.collect {|item| item.code}.uniq
      output = codes.inject("") do |str, code|
          str += self.total_quantity_by_code(code).to_s + " "
          str += code + " "
          str += sprintf( "%0.02f", self.total_cost_by_code(code)) + "\n\t"
          list_str = self.items_by_code(code).collect do |item|
                        "#{quantity_for(item)} X #{item.to_s}"
                      end
          str += list_str.join("\n\t") + "\n"
        end
      output
    end
  end
end