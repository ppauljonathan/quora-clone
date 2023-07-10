RSpec.shared_examples 'Reject Empty Cart' do |action|
  context 'on empty cart' do
    it 'should redirect' do
      credit_transaction = create :credit_transaction, order: order, user: user
      path_helper = public_send("#{action}_order_path", order, transaction_id: credit_transaction.id)
      get(path_helper)
      expect(response).to have_http_status(302)
      expect(flash[:notice]).to eq('cart is empty')
    end
  end
end