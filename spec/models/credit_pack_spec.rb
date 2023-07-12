require 'rails_helper'

RSpec.describe CreditPack, type: :model do
  describe 'validations' do
    it { should validate_presence_of :price }
    it { should validate_presence_of :credit_amount }
  end

  describe 'associations' do
    it { should have_many :line_items }
    it { should have_many :orders }
  end
end
