require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:user) { create :user }
  let(:question) { create :question, user: user }
  let(:draft) { create :question, user: user, save_as_draft: true }

  subject { build :question, user: user }

  it_behaves_like 'Abuse Reportable'
  it_behaves_like 'Notifiable'

  describe 'validations' do
    it { should validate_uniqueness_of :title }
    it { should validate_presence_of :title }
    it 'should validate presence of url_slug' do
      question.validate
      expect(question.errors).to_not include(:url_slug)
    end
  end

  describe 'callbacks' do
    it { is_expected.to callback(:generate_url_slug).before(:validation) }
  end

  describe 'associations' do
    it { should belong_to(:user).without_validating_presence }
    it { should have_many :answers }
    it { should have_many :comments }
    it { should have_many :notifications }
    it { should have_rich_text :content }
  end

  describe 'scopes' do
    context 'drafts' do
      it 'should return drafts' do
        expect(draft).to be_draft
        expect(Question.drafts).to include(draft)
      end

      it 'should not return published questions' do
        expect(question).not_to be_draft
        expect(Question.drafts).not_to include(question)
      end
    end
  end

  describe 'editablility' do
    context 'author' do
      it 'should be falsy on non author' do
        other_user = create :user
        expect(question).to_not be_author(other_user)
      end

      it 'should return true on author' do
        expect(question).to be_author(user)
      end
    end

    context 'editable' do
      it 'should be uneditable if comments exist' do
        question.comments.create(content: 'hello')
        expect(question).to_not be_editable
      end

      it 'should be uneditable if answers exist' do
        question.answers.create(content: 'hello')
        expect(question).to_not be_editable
      end

      it 'should be uneditable if abuse_reports exist' do
        question.abuse_reports.create(content: 'hello')
        expect(question).to_not be_editable
      end

      it 'should be editable otherwise' do
        expect(question).to be_editable
      end
    end
  end

  describe '#unpublish' do
    it 'should unpublish question' do
      question.unpublish
      expect(question).to be_draft
    end
  end
end
