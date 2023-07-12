require 'rails_helper'

RSpec.describe 'Answer', type: :request do
  include AuthHelper

  let(:user) { create :user }
  let(:question) { create :question, user: user }
  let(:answer) { create :answer, question: question, user: user }

  describe 'GET /answers/:id' do
    it_behaves_like 'Answer Authenticable', :get, :answer_path

    context 'when user logged in' do
      before { sign_in user }

      it_behaves_like 'Answer Not Found', :get, :answer_path

      context 'when answer is found' do
        it 'should render show page' do
          get answer_path answer
          expect(response).to have_http_status 200
          expect(request).to have_rendered 'answers/show'
        end
      end
    end
  end

  describe 'POST /answers' do
    it_behaves_like 'Answer Authenticable', :post, :answers_path

    context 'when user is logged in' do
      before { sign_in user }

      context 'with invalid params' do
        it 'should redirect with error' do
          post(answers_path(answer: { content: '', question_id: question.id }))
          expect(response).to have_http_status 302
          expect(flash[:notice]).to eq 'error in creating answer'
        end
      end

      context 'with valid params' do
        it 'should redirect with success' do
          post(answers_path(answer: { content: 'new answer', question_id: question.id }))
          expect(response).to have_http_status 302
          expect(flash[:notice]).to eq 'created successfully'
        end
      end
    end
  end

  describe 'GET /answers/:id/edit' do
    it_behaves_like 'Answer Authenticable', :get, :edit_answer_path

    context 'when user is logged in' do
      before { sign_in user }

      it_behaves_like 'Answer Not Found', :get, :edit_answer_path

      context 'when answer is found' do
        it 'should render edit page' do
          get edit_answer_path answer
          expect(response).to have_http_status 200
          expect(request).to have_rendered 'answers/edit'
        end
      end
    end
  end

  describe 'PATCH /answers/:id' do
    it_behaves_like 'Answer Authenticable', :patch, :answer_path

    context 'when user is logged in' do
      before { sign_in user }

      it_behaves_like 'Answer Not Found', :patch, :answer_path

      context 'when answer is found' do
        context 'with invalid params' do
          it 'should redirect with error' do
            patch(answer_path(answer, answer: { question_id: question.id, content: '' }))
            expect(response).to have_http_status 422
            expect(request).to have_rendered 'answers/edit'
          end
        end

        context 'with valid params' do
          it 'should redirect with success' do
            patch(answer_path(answer, answer: { content: 'edited answer', question_id: question.id }))
            expect(response).to have_http_status 302
            expect(flash[:notice]).to eq 'updated successfully'
          end
        end
      end
    end
  end

  describe 'DELETE /answers/:id' do
    it_behaves_like 'Answer Authenticable', :delete, :answer_path

    context 'when user is logged in' do
      before { sign_in user }

      it_behaves_like 'Answer Not Found', :delete, :answer_path

      context 'when answer is found' do
        it 'should delete answer' do
          delete answer_path answer
          expect(response).to have_http_status 302
          expect(flash[:notice]).to eq 'deleted successfully'
        end
      end
    end
  end
end
