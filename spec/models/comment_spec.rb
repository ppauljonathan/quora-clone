require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create :user }
  let(:other_user) { create :user }
  let(:question) { create :question, user: other_user }
  let(:comment) { create :comment, commentable: question, user: user }

  it_behaves_like 'Votable', :comment
  it_behaves_like 'Abuse Reportable'

  describe 'associations' do
    it { should belong_to :commentable }
    it { should belong_to :user }
    it { should have_rich_text :content }
  end

  describe 'validations' do
    it { should validate_presence_of :content }
  end

  describe '#unpublish' do
    it 'should unpublish comment' do
      comment.unpublish
      expect(comment.published_at).to be_nil
    end
  end
end
