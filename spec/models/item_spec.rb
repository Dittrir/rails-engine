require "rails_helper"

RSpec.describe Item, type: :model do
  describe "relationships" do
    it { should belong_to :merchant}
  end

  describe 'validations' do
    subject { Item.new(name: "Hot Potato", description: "Its a hot potato", unit_price: 1.0) }
    describe '#name' do
      it { should validate_presence_of :name }
      it { should_not allow_value(nil).for(:name) }
    end
    describe '#description' do
      it { should validate_presence_of :description }
      it { should_not allow_value(nil).for(:description) }
    end
    describe '#unit_price' do
      it { should validate_presence_of :unit_price }
      it { should_not allow_value(nil).for(:unit_price) }
      it { should_not allow_value("abcd").for(:unit_price) }
      it { should allow_value("5").for(:unit_price) }
    end
  end
end
