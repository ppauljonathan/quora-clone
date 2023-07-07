RSpec.shared_examples 'Show Action' do |view|
  path_helper = view ? "#{view}_question_path" : :question_path

  context "when published question #{view} is viewed" do
    it "should render questions #{view || 'show'} page" do
      get public_send(path_helper, question)
      expect(response).to have_http_status(200)
      expect(request).to have_rendered("questions/#{view || 'show'}")
    end
  end

  context "when draft question #{view} is viewed" do
    context 'and user not logged in' do
      it 'should redirect' do
        get public_send(path_helper, draft)
        expect(response).to have_http_status(302)
        expect(flash[:alert]).to eq('Cannot access this path')
      end
    end

    context 'and user logged in' do
      before do
        sign_in(user)
      end

      context "and tries to access other users drafts #{view}" do
        it 'should redirect' do
          get public_send(path_helper, other_user_draft)
          expect(response).to have_http_status(302)
          expect(flash[:alert]).to eq('Cannot access this path')
        end
      end

      context "and tries to access their own drafts #{view}" do
        it 'should render draft' do
          get public_send(path_helper, draft)
          expect(response).to have_http_status(200)
          expect(request).to have_rendered("questions/#{view || 'show'}")
        end
      end
    end
  end
end
