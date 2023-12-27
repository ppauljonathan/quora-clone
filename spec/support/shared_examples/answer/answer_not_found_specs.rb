RSpec.shared_examples 'Answer Not Found' do |method, path_helper|
  context 'when answer is not found' do
    it 'should redirect' do
      path = public_send(path_helper, { id: -1 })
      public_send(method, path)
      expect(response).to have_http_status(302)
      expect(flash[:alert]).to eq 'answer not found'
    end
  end
end
