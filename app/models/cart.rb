class Cart
  attr_reader :contents

  def initialize(cart_session_hash)
    @contents = cart_session_hash || Hash.new(0)
  end

  def add_item(item_id)
    @contents[item_id.to_s] = count_of(item_id.to_s) + 1
  end

  def count_of(item_id)
    @contents[item_id.to_s].to_i
  end

  def total_count
    @contents.values.sum
  end
end
