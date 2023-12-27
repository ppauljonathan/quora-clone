require 'rails_helper'

RSpec.describe 'CreditLogs', type: :request do
  include AuthHelper

  let(:user1) { create :user }
  let(:user2) { create :user }

  before do
    create_list :credit_log, 5, user: user1
    create_list :credit_log, 4, user: user2
  end

  describe 'GET /credit_logs' do
    context 'when user not logged in' do
      it 'should redirect' do
        get(credit_logs_path)
        expect(response).to have_http_status 302
        expect(flash[:alert]).to eq 'Please Log in to continue'
      end
    end

    context 'user1 credits log' do
      before { sign_in user1 }

      it 'should render user credit logs' do
        get(credit_logs_path)
        expect(response).to have_http_status 200
        expect(request).to have_rendered 'credit_logs/index'
        expect(assigns(:credit_logs).count).to be 5
      end
    end

    context 'user2 credits log' do
      before { sign_in user2 }

      it 'should render user credit logs' do
        get(credit_logs_path)
        expect(response).to have_http_status 200
        expect(request).to have_rendered 'credit_logs/index'
        expect(assigns(:credit_logs).count).to be 4
      end
    end
  end
end
