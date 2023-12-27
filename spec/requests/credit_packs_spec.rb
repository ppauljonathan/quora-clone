require 'rails_helper'

RSpec.describe 'CreditPacks', type: :request do
  include AuthHelper

  let(:user) { create :user }

  describe 'GET /credit_packs' do
    context 'when user not logged in' do
      it 'should redirect' do
        get(credit_packs_path)
        expect(response).to have_http_status 302
        expect(flash[:alert]).to eq 'Please Log in to continue'
      end
    end

    context 'when user is logged in' do
      before { sign_in user }

      it 'should render all credit packs' do
        get(credit_packs_path)
        expect(response).to have_http_status 200
        expect(assigns(:credit_packs).count).to be 3
      end
    end
  end
end
