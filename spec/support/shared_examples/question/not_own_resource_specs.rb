RSpec.shared_examples 'Not Own Resource' do |method, path_helper|
  context "and tries to #{method} other users question" do
    it 'should redirect' do
      path = public_send(path_helper, other_user_question)
      public_send(method, path)
      expect(response).to have_http_status(302)
      expect(flash[:alert]).to eq('Cannot access this path')
    end
  end
end
