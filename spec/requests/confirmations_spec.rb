require 'rails_helper'

RSpec.describe 'Confirmations', type: :request do
  include AuthHelper

  let(:user) { create :user, verified_at: nil }

  describe 'GET /confirmation' do
    it_behaves_like 'Redirect If Logged In', :get, :confirmation_path

    context 'when user is not logged in' do
      context 'when no verification token is given' do
        it 'should render confirmation page' do
          get(confirmation_path)
          expect(response).to have_http_status(200)
          expect(request).to have_rendered('confirmations/verify')
        end
      end

      context 'when verification token is malformed' do
        it 'should throw error' do
          get(confirmation_path(token: 'fake token'))
          expect(response).to have_http_status(422)
          expect(flash[:alert]).to eq('Token was invalid, enter email to verify again')
        end
      end

      context 'when correct verification token is given' do
        it 'should verify and redirect' do
          get(confirmation_path(token: user.verification_token))
          expect(response).to have_http_status(302)
          expect(flash[:notice]).to eq('email was verified successfully, you can log in now')
          expect(user.reload).to be_verified
        end
      end
    end
  end

  describe 'POST /confirmation' do
    it_behaves_like 'Redirect If Logged In', :post, :confirmation_path

    context 'when user is not logged in' do
      context 'when invalid email entered' do
        it 'should render error' do
          post(confirmation_path(email: 'fake email'))
          expect(response).to have_http_status(422)
          expect(flash[:notice]).to eq('User with given email was not found')
          expect(request).to have_rendered('confirmations/verify')
        end
      end

      context 'when valid email entered' do
        context 'when user already verified' do
          it 'should redirect' do
            user.verify
            post(confirmation_path(email: user.email))
            expect(response).to have_http_status(302)
            expect(flash[:alert]).to eq('User is already verified')
          end
        end

        context 'when user has not been verified' do
          it 'should send verification email' do
            post(confirmation_path(email: user.email))
            expect(response).to have_http_status(302)
          end
        end
      end
    end
  end
end
