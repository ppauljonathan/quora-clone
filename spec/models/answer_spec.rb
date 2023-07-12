require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:user) { create :user }
  let(:other_user) { create :user }
  let(:question) { create :question, user: other_user }
  let(:answer) { create :answer, question: question, user: user }

  it_behaves_like 'Votable', :answer

  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to :question }
    it { should have_many :comments }
    it { should have_rich_text :content }
  end

  describe 'validations' do
    it { should validate_presence_of :content }
  end
end
