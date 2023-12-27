require 'rails_helper'

RSpec.describe CreditLog, type: :model do
  describe 'associations' do
    it { should belong_to :user }
  end

  describe 'callbacks' do
    it { should callback(:change_user_credits).after(:commit) }
  end
end
