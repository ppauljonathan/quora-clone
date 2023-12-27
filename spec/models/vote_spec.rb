require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'enum' do
    it { should define_enum_for :vote_type }
  end

  describe 'associations' do
    it { should belong_to :votable }
    it { should belong_to :user }
  end

  describe 'callbacks' do
    it { should callback(:votable_set_net_upvotes).after(:commit) }
  end
end
