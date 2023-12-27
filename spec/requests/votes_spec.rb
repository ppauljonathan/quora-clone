require 'rails_helper'

RSpec.describe 'Votes', type: :request do
  include AuthHelper

  let(:user) { create :user }
  let(:question) { create :question, user: user }
  let(:votable) { create :answer, question: question }

  describe 'POST /votes/upvote' do
    context 'when user not logged in' do
      it 'should redirect' do
        post(upvote_path(vote: { votable_type: votable.class, votable_id: votable.id }))
        expect(response).to have_http_status 302
        expect(flash[:alert]).to eq 'Please Log in to continue'
      end
    end

    context 'when user logged in' do
      before { sign_in user }

      it 'should upvote' do
        post(upvote_path(vote: { votable_type: votable.class, votable_id: votable.id }))
        expect(response).to have_http_status 200
      end
    end
  end

  describe 'POST /votes/downvote' do
    context 'when user not logged in' do
      it 'should redirect' do
        post(downvote_path(vote: { votable_type: votable.class, votable_id: votable.id }))
        expect(response).to have_http_status 302
        expect(flash[:alert]).to eq 'Please Log in to continue'
      end
    end

    context 'when user logged in' do
      before { sign_in user }

      it 'should downvote' do
        post(downvote_path(vote: { votable_type: votable.class, votable_id: votable.id }))
        expect(response).to have_http_status 200
      end
    end
  end
end
