require 'rails_helper'

RSpec.describe CreditTransaction, type: :model do
  describe 'association' do
    it { should belong_to :order }
    it { should belong_to :user }
  end

  describe 'enum' do
    it { should define_enum_for :status }
  end
end
