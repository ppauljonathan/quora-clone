require 'rails_helper'

RSpec.describe 'Questions', type: :request do
  include AuthHelper

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:other_user_question) { create(:question, user: other_user) }
  let(:draft) { create(:question, user: user, save_as_draft: true) }
  let(:other_user_draft) { create(:question, user: other_user, save_as_draft: true) }

  describe 'GET /questions' do
    before do
      create_list(:question, 5, user: user)
    end

    it 'should render questions page on root path' do
      get root_path
      expect(response).to have_http_status(200)
      expect(request).to have_rendered('questions/index')
    end

    it 'should render published questions' do
      get questions_path
      expect(response).to have_http_status(200)
      expect(request).to have_rendered('questions/index')
      expect(assigns(:questions).size).to eq(5)
    end

    it 'should not render draft questions' do
      create_list(:question, 2, user: user, save_as_draft: true)
      get questions_path
      expect(response).to have_http_status(200)
      expect(request).to have_rendered('questions/index')
      expect(assigns(:questions).size).to eq(5)
    end
  end

  describe 'POST /questions' do
    it_behaves_like 'Authenticable', :post, :questions_path

    context 'when user is logged in' do
      before do
        sign_in(user)
      end

      context 'and posts question' do
        it_behaves_like 'Param Validity', :create
      end
    end
  end

  describe 'GET /questions/:url_slug' do
    it_behaves_like 'Show Action'
  end

  describe 'GET /questions/:url_slug/comments' do
    it_behaves_like 'Show Action', :comments
  end

  describe 'GET /questions/:url_slug/edit' do
    it_behaves_like 'Authenticable', :get, :edit_question_path

    context 'when user is logged in' do
      before do
        sign_in(user)
      end

      it_behaves_like 'Not Own Resource', :get, :edit_question_path

      context 'and tries to edit their own question' do
        it 'should render question edit page' do
          get edit_question_path(question)
          expect(response.status).to eq(200)
          expect(request).to have_rendered('questions/edit')
        end
      end
    end
  end

  describe 'PATCH /questions/:url_slug' do
    it_behaves_like 'Authenticable', :patch, :question_path

    context 'when user is logged in' do
      before do
        sign_in(user)
      end

      it_behaves_like 'Not Own Resource', :patch, :question_path

      context 'and tries to update their own question' do
        it_behaves_like 'Param Validity', :update
      end
    end
  end

  describe 'DELETE /questions/:url_slug' do
    it_behaves_like 'Authenticable', :delete, :question_path

    context 'when user is logged in' do
      before do
        sign_in(user)
      end

      it_behaves_like 'Not Own Resource', :delete, :question_path

      context 'and tries to destroy their own question' do
        it 'should be destroyed' do
          delete question_path(question)
          expect(response).to have_http_status(302)
          expect(flash[:notice]).to eq('Question deleted Successfully')
        end
      end
    end
  end
end
