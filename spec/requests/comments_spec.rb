require 'rails_helper'

RSpec.describe 'Comment', type: :request do
  include AuthHelper

  let(:user) { create :user }
  let(:question) { create :question, user: user }
  let(:comment) { create :comment, commentable_id: question.id, commentable_type: question.class, user: user }

  describe 'POST /comments' do
    it_behaves_like 'Comment Authenticable', :post, :comments_path

    context 'when user is logged in' do
      before { sign_in user }

      context 'with invalid params' do
        it 'should redirect with error' do
          post(comments_path(comment: { content: '',
                                        commentable_id: question.id,
                                        commentable_type: question.class }))
          expect(response).to have_http_status 302
          expect(flash[:notice]).to eq 'error in creating comment'
        end
      end

      context 'with valid params' do
        it 'should redirect with success' do
          post(comments_path(comment: { content: 'new comment',
                                        commentable_id: question.id,
                                        commentable_type: question.class }))
          expect(response).to have_http_status 302
          expect(flash[:notice]).to eq 'created successfully'
        end
      end
    end
  end

  describe 'GET /comments/:id/edit' do
    it_behaves_like 'Comment Authenticable', :get, :edit_comment_path

    context 'when user is logged in' do
      before { sign_in user }

      it_behaves_like 'Comment Not Found', :get, :edit_comment_path

      context 'when comment is found' do
        it 'should render edit page' do
          get edit_comment_path comment
          expect(response).to have_http_status 200
          expect(request).to have_rendered 'comments/edit'
        end
      end
    end
  end

  describe 'PATCH /comments/:id' do
    it_behaves_like 'Comment Authenticable', :patch, :comment_path

    context 'when user is logged in' do
      before { sign_in user }

      it_behaves_like 'Comment Not Found', :patch, :comment_path

      context 'when comment is found' do
        context 'with invalid params' do
          it 'should redirect with error' do
            patch(comment_path(comment,
                               comment: { content: '',
                                          commentable_id: question.id,
                                          commentable_type: question.class }))
            expect(response).to have_http_status 422
            expect(request).to have_rendered 'comments/edit'
          end
        end

        context 'with valid params' do
          it 'should redirect with success' do
            patch(comment_path(comment,
                               comment: { content: 'edited comment',
                                          commentable_id: question.id,
                                          commentable_type: question.class }))
            expect(response).to have_http_status 302
            expect(flash[:notice]).to eq 'updated successfully'
          end
        end
      end
    end
  end

  describe 'DELETE /comments/:id' do
    it_behaves_like 'Comment Authenticable', :delete, :comment_path

    context 'when user is logged in' do
      before { sign_in user }

      it_behaves_like 'Comment Not Found', :delete, :comment_path

      context 'when comment is found' do
        it 'should delete comment' do
          delete comment_path comment
          expect(response).to have_http_status 302
          expect(flash[:notice]).to eq 'deleted successfully'
        end
      end
    end
  end
end
