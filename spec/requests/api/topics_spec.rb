require 'rails_helper'

RSpec.describe 'Api::Topics', type: :request do
  before do
    create_list :question, 5, topic_list: 'topic-1'
    create_list :question, 2, topic_list: 'topic-2'
    create_list :question, 3, topic_list: 'topic-1, topic-2'
  end

  describe 'GET /api/topics/:topic' do
    context 'topic-1' do
      it 'should only give topic 1 questions' do
        get(api_path(topic: 'topic-1'))
        expect(assigns(:questions).count).to be(8)
      end
    end

    context 'topic-2' do
      it 'should only give topic 2 questions' do
        get(api_path(topic: 'topic-2'))
        expect(assigns(:questions).count).to be(5)
      end
    end

    context 'non existent topic' do
      it 'should give an empty array' do
        get(api_path(topic: 'non existing topic'))
        expect(assigns(:questions).count).to be(0)
      end
    end
  end
end
