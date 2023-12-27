require 'rails_helper'

MIN_NET_UPVOTES_FOR_CREDIT = 5
CREDITS_AWARDED = 1

RSpec.describe Answer, type: :model do
  let(:user) { create :user }
  let(:other_user) { create :user }
  let(:question) { create :question, user: other_user }
  let(:answer) { create :answer, question: question, user: user }

  it_behaves_like 'Votable', :answer
  it_behaves_like 'Abuse Reportable'

  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to :question }
    it { should have_many :comments }
    it { should have_rich_text :content }
  end

  describe 'validations' do
    it { should validate_presence_of :content }
  end

  describe '#unpublish' do
    it 'should unpublish answer and rollback credits given' do
      answer = create :answer, question: question, user: user, net_upvote_count: (MIN_NET_UPVOTES_FOR_CREDIT + 1)
      original_credits = user.credits

      answer.unpublish
      expect(answer.published_at).to be_nil
      expect(user.credits).to eq(original_credits - CREDITS_AWARDED)
    end
  end
end
