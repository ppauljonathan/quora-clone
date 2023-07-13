require 'rails_helper'

RSpec.describe 'AbuseReports', type: :request do
  include AuthHelper

  let!(:user) { create :user }

  describe 'POST /abuse_reports' do
    context 'when user not logged in' do
      it 'should redirect' do
        post abuse_reports_path
        expect(response).to have_http_status 302
        expect(flash[:alert]).to eq 'Please Log in to continue'
      end
    end

    context 'when user logged in' do
      let(:reportable) { create :question, user: user }

      before { sign_in user }

      it 'should report abuse' do
        post(abuse_reports_path(abuse_report: { reportable_type: reportable.class,
                                                reportable_id: reportable.id,
                                                content: 'abusive content' }))
        expect(response).to have_http_status 302
        expect(flash[:notice]).to eq 'reported'
      end

      it 'should not allow same user to report twice' do
        create :abuse_report, :for_question, reportable: reportable, user: user

        post(abuse_reports_path(abuse_report: { reportable_type: reportable.class,
                                                reportable_id: reportable.id,
                                                content: 'abusive content' }))
        expect(response).to have_http_status 302
        expect(flash[:alert]).to eq 'something went wrong'
      end
    end
  end
end
