require 'rails_helper'

RSpec.describe 'Passwords', type: :request do
  include AuthHelper

  let(:user) { create :user }

  describe 'GET /reset_password' do
    it_behaves_like 'Redirect If Logged In', :get, :reset_password_path

    context 'when user is not logged in' do
      it 'should render reset view' do
        get(reset_password_path)
        expect(response).to have_http_status(200)
        expect(request).to have_rendered('passwords/new')
      end
    end
  end

  describe 'POST /reset_password' do
    it_behaves_like 'Redirect If Logged In', :post, :reset_password_path

    context 'when user is not logged in' do
    end
  end

  describe 'GET /reset_password/edit' do
    it_behaves_like 'Redirect If Logged In', :get, :reset_password_edit_path

    context 'when user is not logged in' do
      context 'when token is malformed' do
        it 'should redirect' do
          get(reset_password_edit_path)
          expect(response).to have_http_status(302)
          expect(flash[:notice]).to eq('the token was not valid, please initiate reset password action again')
        end
      end

      context 'when token is valid' do
        it 'should render edit password view' do
          user.send_reset_mail
          get(reset_password_edit_path(token: user.reset_token))
          expect(response).to have_http_status(200)
          expect(request).to have_rendered('passwords/edit')
        end
      end
    end
  end

  describe 'PATCH /reset_password' do
    it_behaves_like 'Redirect If Logged In', :patch, :reset_password_path

    context 'when user is not logged in' do
      it 'should reset password' do
        user_params = { id: user.id, password: 'new password' }
        patch(reset_password_path(user: user_params))
        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eq('password has been reset successfully, please login')
      end
    end
  end
end
