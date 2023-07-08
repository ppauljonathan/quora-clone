require 'rails_helper'

CREDITS_ON_VERIFICATION = 5

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build :user }
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    describe 'email should be of specified format' do
      it 'should accept if valid format' do
        user = build :user
        user.save
        expect(user).to be_persisted
      end

      it 'should not accept invalid format' do
        user = build :user, email: 'invalid email'
        user.save
        expect(user).to be_new_record
        expect(user.errors[:email]).to include('is invalid')
      end
    end
  end

  describe 'callbacks' do
    it { is_expected.to callback(:generate_verification_token).before(:create) }
    it { is_expected.to callback(:generate_api_token).before(:create) }
    it { is_expected.to callback(:send_verification_email).after(:commit) }
  end

  describe 'associations' do
    it { should have_and_belong_to_many :followers }
    it { should have_and_belong_to_many :followees }
    it { should have_many :notifications }
    it { should have_many :orders }
    it { should have_many :credit_transactions }
    it { should have_many :abuse_reports }
    it { should have_many :questions }
    it { should have_many :answers }
    it { should have_many :comments }
    it { should have_many :votes }
    it { should have_many :credit_logs }
    it { should have_one_attached :profile_picture}
    it { should have_secure_password }
  end

  let(:user) { create :user }
  let(:other_user) { create :user }

  describe 'user verification' do
    it 'should not verify user if already verified' do
      verification_time = 1.day.ago
      user.verified_at = verification_time
      user.verify
      expect(user.verified_at).to eq(verification_time)
    end

    it 'should verify an unverified user' do
      user.verified_at = nil
      user.credits = 0
      user.verify
      expect(user.verification_token).to be_nil
      expect(user).to be_verified
      expect(user.credits).to eq(CREDITS_ON_VERIFICATION)
    end
  end

  describe 'user soft delete' do
    before { user.disable }

    it 'should not delete user' do
      expect(user).not_to be_destroyed
    end

    it 'should not be able to find User' do
      expect(User.find_by_id(user.id)).to be_nil
    end
  end

  describe 'user enable' do
    before do
      user.disabled_at = Time.now
      user.enable
    end

    it 'should enable user' do
      expect(user.disabled_at).to be_nil
    end

    it 'should not be able to find User' do
      expect(User.find_by_id(user.id)).not_to be_nil
    end
  end

  describe 'resending verification email' do
    it 'should reset verification process' do
      user.resend_verification_mail
      expect(user).not_to be_verified
      expect(user.verification_token).not_to be_nil
    end
  end

  describe 'following' do
    context 'when following' do
      it 'should follow other user' do
        user.follow other_user
        expect(other_user.followers).to include(user)
        expect(user.followees).to include(other_user)
      end

      it 'should not follow other user more than once' do
        user.follow other_user
        expect(user.follow(other_user)).to be false
        expect(user.followees).to include(other_user)
      end
    end

    context 'when unfollowing' do
      before { user.followees << other_user }
      it 'should unfollow the other user' do
        user.unfollow other_user
        expect(other_user.followers).not_to include(user)
        expect(user.followees).not_to include(other_user)
      end
    end
  end

  describe 'update credits' do
    it 'should create credit_log' do
      user.credits = 0
      user.update_credits(10, 'test')
      expect(user.credits).to eq(10)
      expect(user.credit_logs.first.credit_amount).to eq(10)
      expect(user.credit_logs.first.remark).to eq('test')
    end
  end
end
