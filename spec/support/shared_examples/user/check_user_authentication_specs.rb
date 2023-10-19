RSpec.shared_examples 'Check User Authentication' do |member, method|
  path_helper = member.blank? ? :user_path : "#{member}_user_path"
  it 'redirects to login if user is not found' do
    user_id = -1
    path = public_send(path_helper, id: user_id)
    public_send(method, path)
    expect(response.status).to be(302)
    expect(flash[:alert]).to eq('Please Log in to continue')
  end

  context 'when user is not logged in' do
    it 'should redirect to login' do
      path = public_send(path_helper, user)
      public_send(method, path)
      expect(response.status).to be(302)
      expect(flash[:alert]).to eq('Please Log in to continue')
    end
  end
end
