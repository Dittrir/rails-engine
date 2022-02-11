RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it { should have_many :items}
  end

  describe 'validations' do
    subject { Merchant.new(name: "Mr.Potato") }
    describe '#name' do
      it { should validate_presence_of :name }
      it { should_not allow_value(nil).for(:name) }
    end
  end
end
