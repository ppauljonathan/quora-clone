require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  include AuthHelper

  describe 'GET /login' do
    it_behaves_like 'Redirect If Logged In', :get, :login_path

    context 'when user not logged in' do
      it 'should render login page' do
        get(login_path)
        expect(response).to have_http_status(200)
        expect(response).to have_rendered('sessions/new')
      end
    end
  end

  describe 'POST /login' do
    it_behaves_like 'Redirect If Logged In', :post, :login_path

    context 'when user not logged in' do
      it 'should log in user' do
        user = create :user
        post(login_path(user: { email: user.email, password: user.password }))
        expect(response).to have_http_status(302)
        expect(cookies[:user_id]).to_not be_blank
      end
    end
  end

  describe 'DELETE /logout' do
    context 'when user not logged in' do
      it 'should redirect' do
        delete(logout_path)
        expect(response).to have_http_status(302)
        expect(response.location).to eq(login_url)
      end
    end

    context 'when user logged in' do
      before { sign_in create(:user) }

      it 'should log out user' do
        delete(logout_path)
        expect(response).to have_http_status(302)
        expect(cookies[:user_id]).to be_blank
      end
    end
  end
end
