RSpec.shared_examples 'Comment Not Found' do |method, path_helper|
  context 'when comment is not found' do
    it 'should redirect' do
      path = public_send(path_helper, { id: -1 })
      public_send(method, path)
      expect(response).to have_http_status(302)
      expect(flash[:alert]).to eq 'comment not found'
    end
  end
end
