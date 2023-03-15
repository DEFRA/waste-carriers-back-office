# frozen_string_literal: true

require "rails_helper"

RSpec.describe "EmailExports" do
  describe "GET /bo/email-exports" do

    context "when a CBD user is signed in" do
      let(:user) { create(:user, role: :cbd_user) }

      before { sign_in(user) }

      it "renders the email_export new template" do
        get "/bo/email-exports/new"

        expect(response).to render_template(:new)
      end

      it "returns a 200 response" do
        get "/bo/email-exports/new"

        expect(response).to have_http_status(:ok)
      end
    end

    context "when a non-CBD user is signed in" do
      let(:user) { create(:user, role: :agency) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/bo/email-exports/new"

        expect(response).to redirect_to("/bo/pages/permission")
      end
    end

    context "when no user is signed in" do
      it "redirects the user to the sign in page" do
        get "/bo/email-exports/new"

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /bo/email-exports" do
    before { allow(DeregistrationEmailExportService).to receive(:run) }

    context "when a CBD user is signed in" do
      let(:user) { create(:user, role: :cbd_user) }

      before { sign_in(user) }

      it "runs the DeregistrationEmailExportService" do
        post "/bo/email-exports", params: { batch_size: 5 }

        expect(DeregistrationEmailExportService).to have_received(:run)
      end

      it "redirects to the exports list page" do
        post "/bo/email-exports", params: { batch_size: 5 }

        expect(response).to redirect_to(new_email_exports_list_path)
      end
    end

    context "when a non-CBD user is signed in" do
      let(:user) { create(:user, role: :agency) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        post "/bo/email-exports", params: { batch_size: 5 }

        expect(response).to redirect_to("/bo/pages/permission")
      end
    end

    context "when no user is signed in" do
      it "redirects the user to the sign in page" do
        post "/bo/email-exports", params: { batch_size: 5 }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /bo/email-exports/:id" do
    let(:user) { create(:user, role: :cbd_user) }
    let(:export_log) { create(:email_export_log) }

    before do
      sign_in(user)
      get email_exports_path(id: export_log.id)
    end

    it "logs the visit to the export file" do
      export_log = EmailExportLog.last
      download_log = export_log.download_log.last
      expect(download_log[:by]).to eq user.email
      expect(download_log[:at]).to be_within(1.second).of(DateTime.now)
    end

    it "redirects the user to the AWS S3 download link" do
      expect(response).to have_http_status(:found)
      # Match against location instead of expect redirect_to in order to exclude
      # variable "X-Amz-"" parameters from the comparison.
      expected_redirect_url = EmailExportLog.first.download_link.split("&X-Amz")[0]
      expect(response.location).to start_with(expected_redirect_url)
    end
  end
end
