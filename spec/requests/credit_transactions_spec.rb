require 'rails_helper'

RSpec.describe "CreditTransactions", type: :request do
  include AuthHelper

  let!(:user) { create :user }
  let!(:order) { create :order, user: user }
  let!(:credit_transactions) {create_list :credit_transaction, 5, user: user, order: order, stripe_session_id: 'abcd'}

  describe "GET /credit_transactions" do
    context 'when user not logged in' do
      it 'should redirect' do
        get(credit_transactions_path)
        expect(response).to have_http_status 302
        expect(flash[:alert]).to eq 'Please Log in to continue'
      end
    end

    context 'when user logged in' do
      before { sign_in user }

      it 'should render credit transactions' do
        get(credit_transactions_path)
        expect(response).to have_http_status 200
        expect(assigns(:credit_transactions).count).to be 5
      end
    end
  end

  describe 'GET /credit_transactions/:id' do
    context 'when user not logged in' do
      it 'should redirect' do
        get(credit_transaction_path(credit_transactions[0]))
        expect(response).to have_http_status 302
        expect(flash[:alert]).to eq 'Please Log in to continue'
      end
    end

    context 'when user is logged in' do
      before { sign_in user }

      it 'should render credit transaction' do
        get(credit_transaction_path(credit_transactions[0]))
        expect(response).to have_http_status 200
        expect(request).to have_rendered 'credit_transactions/show'
      end
    end
  end
end
