RSpec.shared_examples 'Abuse Reportable' do
  describe 'abuse reportable association' do
    it { should have_many :abuse_reports }
  end

  describe 'abuse reportable callbacks' do
    it { should callback(:publish).before(:save).unless(:save_as_draft) }
  end
end
