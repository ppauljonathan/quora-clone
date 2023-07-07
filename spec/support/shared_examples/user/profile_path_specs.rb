RSpec.shared_examples 'Profile Path' do |action|
  context 'when user is logged in' do
    before do
      sign_in(user)
    end

    context "and accesses others #{action} page" do
      let(:other_user) { create(:user) }

      it 'should redirect' do
        get public_send("#{action}_user_path", other_user)
        expect(response.status).to be(302)
        expect(flash[:notice]).to eq('cannot access this path')
      end
    end

    context "and accesses their #{action} page" do
      it "should render #{action}" do
        get public_send("#{action}_user_path", user)
        expect(response.status).to be(200)
        expect(request).to have_rendered(action.to_s)
      end
    end
  end
end
