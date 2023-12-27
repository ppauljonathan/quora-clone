require 'rails_helper'

RSpec.describe 'Api::Questions', type: :request do
  let(:user) { create :user, topic_list: 'topic-1' }

  before do
    create_list :question, 5, topic_list: 'topic-1'
    create_list :question, 2, topic_list: 'topic-2'
    create_list :question, 3, topic_list: 'topic-1, topic-2'
  end

  describe 'GET /api/questions?token=mytoken' do
    context 'with fake api token' do
      it 'should throw error' do
        get(api_feed_path(token: 'fake token'))
        expect(response).to have_http_status 422
      end
    end

    context 'with correct api key' do
      it 'should give questions matching with user\'s topics' do
        get(api_feed_path(token: user.api_token))
        expect(response).to have_http_status 200
        expect(assigns(:questions).count).to be 8
      end
    end
  end
end
