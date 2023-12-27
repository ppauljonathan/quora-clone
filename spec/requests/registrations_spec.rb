require 'rails_helper'

RSpec.describe 'Registrations', type: :request do
  include AuthHelper

  describe 'GET /signup' do
    it_behaves_like 'Redirect If Logged In', :get, :signup_path

    context 'when user is not logged in' do
      it 'should render signup page' do
        get(signup_path)
        expect(response).to have_http_status(200)
        expect(request).to have_rendered('registrations/new')
      end
    end
  end

  describe 'POST /signup' do
    it_behaves_like 'Redirect If Logged In', :post, :signup_path

    context 'when user is not logged in' do
      it 'should create user' do
        user_params = { user: { email: 'abc@123.com', name: 'abc', password: 'secret' } }
        post(signup_path(user_params))
        expect(response).to have_http_status(302)
        expect(flash[:token_notice]).to eq('Verify your email to login')
      end
    end
  end
end
