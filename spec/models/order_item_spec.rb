RSpec.describe OrderItem, type: :model do
  describe "Validations" do
    it { should validate_presence_of :price_per_item}
    it { should validate_presence_of :quantity}
  end

  describe "relationships" do
    it { should belong_to :item}
    it { should belong_to :order}
  end
end
