require 'rails_helper'

RSpec.describe 'User requests', type: :request do
  include AuthHelper

  let(:user) { create :user }

  after do
    User.destroy_all
  end

  describe 'GET /users/:id' do
    it 'should redirect if user not found' do
      user_id = -1
      get user_path(id: user_id)
      expect(response).to have_http_status(302)
      expect(flash[:alert]).to eq('user not found')
    end

    it 'should render users show page' do
      get user_path(user)
      expect(response).to have_http_status(200)
      expect(request).to have_rendered('show')
    end
  end

  %i[edit drafts].each do |member|
    describe "GET /users/:id/#{member}" do
      it_behaves_like 'Check User Authentication', member, :get
      it_behaves_like 'Profile Path', member
    end
  end

  describe 'PATCH /users/:id' do
    it_behaves_like 'Check User Authentication', nil, :patch

    context 'when user is logged in' do
      before do
        sign_in(user)
      end

      context 'and accesses others update action' do
        let(:other_user) { create(:user) }

        it 'should redirect' do
          patch user_path(other_user)
          expect(response).to have_http_status(302)
          expect(flash[:notice]).to eq('cannot access this path')
        end
      end

      context 'and accesses their update action' do
        context 'with invalid params' do
          it 'should not update' do
            patch user_path(user, user: { name: '' })
            expect(request).to have_rendered('edit')
            expect(response).to have_http_status(422)
          end
        end
        context 'with valid params' do
          it 'should update' do
            patch user_path(user, user: { name: 'Updated Name' })
            expect(response).to have_http_status(302)
            expect(flash[:notice]).to eq('succesfully updated')
          end
        end
      end
    end
  end

  describe 'DELETE /users/:id' do
    it_behaves_like 'Check User Authentication', nil, :delete

    context 'when user is logged in' do
      before do
        sign_in(user)
      end

      context 'and accesses others destroy action' do
        let(:other_user) { create(:user) }

        it 'should redirect' do
          delete user_path(other_user)
          expect(response).to have_http_status(302)
          expect(flash[:notice]).to eq('cannot access this path')
        end
      end

      context 'and accesses their update action' do
        it 'should delete user' do
          delete user_path(user)
          expect(response).to have_http_status(302)
          expect(flash[:notice]).to eq('User deleted Successfully')
        end
      end
    end
  end

  %i[answers questions comments followers followees].each do |association|
    describe "GET /users/:id/#{association}" do
      it_behaves_like 'User Association', association
    end
  end

  describe 'POST /users/:id/follow' do
    it_behaves_like 'Check User Authentication', :follow, :post

    context 'when user is logged in' do
      before do
        sign_in(user)
      end

      it 'should not be able to follow themself' do
        post follow_user_path(user)
        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eq('cannot follow self')
      end

      it 'should be able to follow other user' do
        other_user = create :user
        post follow_user_path(other_user)
        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eq('successful')
        expect(other_user.followers).to include(user)
      end
    end
  end

  describe 'POST /users/:id/unfollow' do
    it_behaves_like 'Check User Authentication', :unfollow, :post

    context 'when user is logged in' do
      before do
        sign_in(user)
      end

      it 'should not be able to unfollow themself' do
        post unfollow_user_path(user)
        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eq('cannot follow self')
      end

      it 'should be able to unfollow other user' do
        other_user = create :user
        other_user.followers << user
        post unfollow_user_path(other_user)
        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eq('successful')
        expect(other_user.followers).not_to include(user)
      end
    end
  end
end
