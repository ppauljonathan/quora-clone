RSpec.shared_examples 'Redirect If Logged In' do |method, path_helper|
  context 'when user is logged in' do
    before { sign_in create(:user) }

      it 'should redirect' do
        path = public_send path_helper
        public_send method, path
        expect(response).to have_http_status(302)
        expect(response.location).to eq(root_url)
      end
  end
end
