class Cart
  attr_reader :contents

  def initialize(cart_session_hash)
    @contents = cart_session_hash || Hash.new(0)
  end

  def add_item(item_id)
    @contents[item_id.to_s] = count_of(item_id.to_s) + 1
  end

  def total_count
    @contents.values.sum
  end

  def count_of(item_id)
    @contents[item_id.to_s].to_i
  end

  def item_and_quantity_hash
    @contents.map do |item_id, quantity|
      [Item.find(item_id.to_i), quantity]
    end.to_h
  end

  def subtotal(item)
    quantity = item_and_quantity_hash[item]
    item.price * quantity
  end

  def grand_total
    item_and_quantity_hash.sum do |item, quantity|
      item.price * quantity
    end
  end
end
