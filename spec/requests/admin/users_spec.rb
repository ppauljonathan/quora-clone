require 'rails_helper'

RSpec.describe 'Admin::Users', type: :request do
  include AuthHelper

  let!(:admin) { create :user, :admin }
  let!(:user) { create :user }
  let!(:disabled_user) { create :user, :disabled }

  describe 'GET /admin/users' do
    it_behaves_like 'Admin Users Authenticable', :get, :admin_users_path

    context 'when admin logged in' do
      before { sign_in admin }

      it 'should render index page' do
        get(admin_users_path)
        expect(response).to have_http_status 200
        expect(request).to have_rendered 'admin/users/index'
        expect(assigns(:users)).to include disabled_user
        expect(assigns(:users)).to include user
      end
    end
  end

  describe 'POST /admin/users/:id/enable' do
    it_behaves_like 'Admin Users Authenticable', :post, :enable_admin_user_path

    context 'when admin logged in' do
      before { sign_in admin }

      it 'should enable a user' do
        post(enable_admin_user_path(disabled_user))
        expect(response).to have_http_status 302
        expect(flash[:notice]).to eq 'user enabled successfully'
        expect(disabled_user.reload.disabled_at).to be_nil
      end
    end
  end

  describe 'POST /admin/users/:id/disable' do
    it_behaves_like 'Admin Users Authenticable', :post, :disable_admin_user_path

    context 'when admin logged in' do
      before { sign_in admin }

      it 'should enable a user' do
        post(disable_admin_user_path(disabled_user))
        expect(response).to have_http_status 302
        expect(flash[:notice]).to eq 'user disabled successfully'
        expect(disabled_user.reload.disabled_at).not_to be_nil
      end
    end
  end
end
