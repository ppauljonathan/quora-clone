require 'rails_helper'

RSpec.describe 'Admin::Questions', type: :request do
  include AuthHelper

  let!(:admin) { create :user, :admin }
  let!(:user) { create :user }
  let!(:question) { create :question, user: user }
  let!(:unpublished_question) { create :question, user: admin, save_as_draft: true }

  describe 'GET /admin/questions' do
    it_behaves_like 'Admin Questions Authenticable', :get, :admin_questions_path

    context 'when admin logged in' do
      before { sign_in admin }

      it 'should show questions page' do
        get(admin_questions_path)
        expect(response).to have_http_status 200
        expect(request).to have_rendered 'admin/questions/index'
        expect(assigns(:questions)).to include question
        expect(assigns(:questions)).not_to include unpublished_question
      end
    end
  end

  describe 'POST /admin/questions/:url_slug/unpublish' do
    it_behaves_like 'Admin Questions Authenticable', :post, :unpublish_admin_question_path

    context 'when admin logged in' do
      before { sign_in admin }

      it 'should unpublish question' do
        post(unpublish_admin_question_path(question))
        expect(response).to have_http_status 302
        expect(flash[:notice]).to eq('Question unpublished Successfully')
        # expect(question.reload)
      end
    end
  end
end
