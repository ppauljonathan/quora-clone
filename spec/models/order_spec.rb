require 'rails_helper'

SUCCESS_URL = 'http://example.com/orders/success'.freeze
CANCEL_URL = 'http://example.com/orders/cancel'.freeze
STRIPE_URL_REGEX = %r{^https://checkout.stripe.com/c/pay}

RSpec.describe Order, type: :model do
  let(:user) { create :user }
  let(:order) { create :order, user: user }

  describe 'callbacks' do
    it { is_expected.to callback(:set_number).before(:create) }
  end

  describe 'associations' do
    it { should belong_to :user }
    it { should have_many :credit_transactions }
    it { should have_many :line_items }
    it { should have_many :credit_packs }
  end

  describe '#checkout' do
    it 'should generate stripe session and credit transaction' do
      create :line_item, order: order
      stripe_session_url = order.checkout SUCCESS_URL, CANCEL_URL
      expect(order.credit_transactions).not_to be_empty
      expect(stripe_session_url).to match_regex(STRIPE_URL_REGEX)
    end
  end

  describe '#clear_cart' do
    before do
      with_options order: order do
        create :line_item, credit_pack_id: 1
        create :line_item, credit_pack_id: 2, quantity: 2
        create :line_item, credit_pack_id: 3, quantity: 4
      end
    end
    it 'should destroy all line items' do
      order.clear_cart
      expect(order.line_items).to be_empty
    end
  end

  describe '#set_amount' do
    before do
      with_options order: order do
        create :line_item, credit_pack_id: 1
        create :line_item, credit_pack_id: 2, quantity: 2
        create :line_item, credit_pack_id: 3, quantity: 4
      end
    end

    it 'should set the total amount of the order' do
      expected_amount = (499.99 * 1) + (949.99 * 2) + (1799.99 * 4)
      order.set_amount
      expect(order.amount.to_f).to eq(expected_amount)
    end
  end
end
