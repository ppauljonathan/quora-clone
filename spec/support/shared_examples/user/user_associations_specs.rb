RSpec.shared_examples 'User Association' do |association|
  it "renders users #{association} page" do
    get public_send("#{association}_user_path", user)
    expect(response.status).to be(200)
    expect(request).to have_rendered(association.to_s)
  end

  it 'redirects if user is not found' do
    user_id = -1
    get public_send("#{association}_user_path", id: user_id)
    expect(response.status).to be(302)
    expect(flash[:alert]).to eq('user not found')
  end
end
