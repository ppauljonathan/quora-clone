require 'rails_helper'

RSpec.describe LineItem, type: :model do
  let(:order) { create :order }
  let(:line_item) { create :line_item, order: order, quantity: 15 }
  describe 'validations' do
    it { should validate_numericality_of(:quantity).is_in(1..20) }
  end

  describe 'callbacks' do
    it { is_expected.to callback(:update_amount).before(:save) }
    it { is_expected.to callback(:update_order_amount).after(:commit) }
  end

  describe 'associations' do
    it { should belong_to :order }
    it { should belong_to :credit_pack }
  end

  describe '#update_quantity_by(number)' do
    it 'should update quantity' do
      line_item.update_quantity_by(-5)
      expect(line_item.quantity).to be(10)
    end
  end
end
