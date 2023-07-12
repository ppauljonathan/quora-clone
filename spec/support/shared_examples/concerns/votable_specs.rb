RSpec.shared_examples 'Votable' do |votable_name|
  let(:votable) do
    if votable_name == :answer
      create votable_name, question: question, user: user
    else
      create votable_name, commentable: question, user: user
    end
  end

  describe 'votable association' do
    it { should have_many :votes }
  end

  describe 'votable callbacks' do
    it { should callback(:set_credits).after(:commit).if(:net_upvote_count_previously_changed?) }
  end

  describe '#downvote' do
    before { votable.downvote(other_user.id) }

    it 'should downvote' do
      vote = votable.votes.find_by_user_id(other_user.id)
      expect(vote).to be_downvote
    end
  end

  describe '#set_net_upvotes' do
    context 'when upvoted' do
      before { votable.upvote(other_user.id) }

      it 'should increase net_upvote_count' do
        expect(votable.net_upvote_count).to be(1)
      end
    end

    context 'when downvoted' do
      before { votable.downvote(other_user.id) }

      it 'should decrease net_upvote_count' do
        expect(votable.net_upvote_count).to be(-1)
      end
    end
  end

  describe '#upvote' do
    before { votable.upvote(other_user.id) }

    it 'should downvote' do
      vote = votable.votes.find_by_user_id(other_user.id)
      expect(vote).to be_upvote
    end
  end

  describe '#vote_by_user' do
    context 'on no vote' do
      it 'should return nil' do
        expect(votable.vote_by_user(other_user)).to be_nil
      end
    end

    context 'on upvote' do
      before { votable.upvote(other_user.id) }

      it 'should return :upvote' do
        expect(votable.vote_by_user(other_user)).to eq('upvote')
      end
    end

    context 'on downvote' do
      before { votable.downvote(other_user.id) }

      it 'should return :downvote' do
        expect(votable.vote_by_user(other_user)).to eq('downvote')
      end
    end
  end
end
