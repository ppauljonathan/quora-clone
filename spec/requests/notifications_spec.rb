require 'rails_helper'

RSpec.describe 'Notifications', type: :request do
  include AuthHelper

  let!(:user) { create :user }
  let!(:question) { create :question, user: user }
  let!(:notification) { create :notification, notifiable: question, user: user }

  describe 'GET /notifications' do
    context 'when user not logged in' do
      it 'should redirect' do
        get notifications_path
        expect(response).to have_http_status 302
        expect(flash[:alert]).to eq 'Please Log in to continue'
      end
    end

    context 'when user is logged in' do
      before { sign_in user }

      it 'should render their notifications' do
        get notifications_path
        expect(response).to have_http_status 200
        expect(request).to have_rendered 'notifications/index'
        expect(assigns(:notifications)).to include notification
      end
    end
  end

  describe 'POST /notifications/read_all' do
    context 'when user not logged in' do
      it 'should redirect' do
        post read_all_notifications_path
        expect(response).to have_http_status 302
        expect(flash[:alert]).to eq 'Please Log in to continue'
      end
    end

    context 'when user is logged in' do
      before { sign_in user }

      it 'should mark their notifications as read' do
        post read_all_notifications_path
        expect(response).to have_http_status 200
        expect(notification.reload).to be_read
      end
    end
  end
end
