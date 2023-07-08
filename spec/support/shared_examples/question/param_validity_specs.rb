RSpec.shared_examples 'Param Validity' do |method|
  context 'with invalid params' do
    it "should render #{method == :create ? 'new' : 'edit'} page with errors" do
      params = { question: { title: '' } }
      if method == :create
        post questions_path(params: params)
      else
        patch question_path(question, params: params)
      end
      expect(response).to have_http_status(422)
      expect(response).to have_rendered("questions/#{method == :create ? 'new' : 'edit'}")
    end
  end

  context 'with valid params' do
    it "should redirect to homepage after #{method == :create ? 'creating' : 'editing'}" do
      params = { question: attributes_for(:question, user: user) }
      if method == :create
        post questions_path(params: params)
      else
        patch question_path(question, params: params)
      end
      expect(response).to have_http_status(302)
      expect(flash[:notice]).to eq("Question #{method == :create ? 'Created' : 'Updated'}")
    end
  end
end
