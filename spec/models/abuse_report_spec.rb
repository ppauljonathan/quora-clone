require 'rails_helper'

MAX_REPORTED_BY = 5

RSpec.describe AbuseReport, type: :model do
  describe 'callbacks' do
    it { should callback(:check_reports).after(:commit) }
  end

  describe 'associations' do
    it { should have_rich_text :content }
    it { should belong_to :reportable }
    it { should belong_to :user }
  end

  describe 'validations' do
    let(:user) { create :user }
    let(:question) { create :question, user: user }

    subject { AbuseReport.new(user: user, reportable: question) }

    it { should validate_uniqueness_of(:user_id).scoped_to(%i[reportable_type reportable_id]) }
    it { should validate_presence_of :content }
  end

  describe 'unpublising' do
    it "should unpublish after #{MAX_REPORTED_BY + 1} abuse reports" do
      question = create :question, user: create(:user)

      (MAX_REPORTED_BY + 1).times do
        create :abuse_report, :for_question, reportable: question, user: create(:user)
      end
      expect(question.published_at).to be_nil
    end
  end
end
