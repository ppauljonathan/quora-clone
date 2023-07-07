RSpec.shared_examples 'Authenticable' do |method, path_helper|
  context 'when user is not logged in' do
    it 'should redirect' do
      path = path_helper == :questions_path ? public_send(:questions_path) : public_send(path_helper, question)
      public_send(method, path)
      expect(response).to have_http_status(302)
      expect(flash[:alert]).to eq('Please Log in to continue')
    end
  end
end
