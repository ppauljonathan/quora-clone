RSpec.shared_examples 'Comment Authenticable' do |method, path_helper|
  context 'when user not logged in' do
    it 'should redirect' do
      path = path_helper == :comments_path ? public_send(:comments_path) : public_send(path_helper, comment)
      public_send(method, path)
      expect(response).to have_http_status(302)
      expect(flash[:alert]).to eq('Please Log in to continue')
    end
  end
end
