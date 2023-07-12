require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create :user }
  let(:other_user) { create :user }
  let(:question) { create :question, user: other_user }
  let(:comment) { create :answer, commentable: question, user: user }

  it_behaves_like 'Votable', :comment

  describe 'associations' do
    it { should belong_to :commentable }
    it { should belong_to :user }
    it { should have_rich_text :content }
  end

  describe 'validations' do
    it { should validate_presence_of :content }
  end
end
