RSpec.shared_examples 'Notifiable' do
  describe 'notifiable callbacks' do
    it { should callback(:post_notification).after(:commit) }
  end
end
