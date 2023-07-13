require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'associations' do
    it { should belong_to :notifiable }
    it { should belong_to :user }
  end

  describe 'validations' do
    let(:user) { create :user }
    let(:question) { create :question, user: user }

    subject { Notification.new(user: user, notifiable: question) }

    it { should validate_uniqueness_of(:user_id).scoped_to(%i[notifiable_type notifiable_id]) }
  end

  describe 'enum' do
    it { should define_enum_for :status }
  end
end
