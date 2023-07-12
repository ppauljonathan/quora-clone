RSpec.shared_examples 'Admin Questions Authenticable' do |method, path_helper|
  context 'when user not logged in' do
    it 'should redirect' do
      path = path_helper == :admin_questions_path ? public_send(:admin_questions_path) : public_send(path_helper, question)
      public_send(method, path)
      expect(response).to have_http_status(302)
      expect(flash[:alert]).to eq('Please Log in to continue')
    end
  end

  context 'when non admin user logged in' do
    before { sign_in user }

    it 'should redirect' do
      path = path_helper == :admin_questions_path ? public_send(:admin_questions_path) : public_send(path_helper, question)
      public_send(method, path)
      expect(response).to have_http_status 302
      expect(flash[:notice]).to eq 'cannot access this path'
    end
  end
end
