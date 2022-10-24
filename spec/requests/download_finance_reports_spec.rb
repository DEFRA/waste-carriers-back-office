# frozen_string_literal: true

require "rails_helper"

RSpec.describe "DownloadFinanceReports" do

  # for checking tmp dirs before and after tests, to support tmp file cleanup
  def tmp_dirs
    Dir[File.join(Pathname.new(Dir.mktmpdir).dirname, "*")]
  end

  describe "GET /bo/download_finance_reports" do

    context "when a cbd_user is signed in" do
      let(:user) { create(:user, :cbd_user) }
      let(:report_filename) { "report_file_2022-08-25_01-23-45.zip" }
      let(:folder_prefix) { "SOME_FOLDER" }
      let(:download_link) { "https://some_bucket.amazonaws.com/#{folder_prefix}/#{report_filename}" }

      before do
        sign_in(user)
        allow_any_instance_of(Reports::FinanceReportsAwsService).to receive(:download_link).and_return(download_link)
      end

      it "returns HTTP status 200" do
        get finance_reports_path

        expect(response).to have_http_status(:ok)
      end

      it "response includes the download URL" do
        get finance_reports_path

        expect(response.body).to include(download_link)
      end

      it "response includes the name of the report file" do
        get finance_reports_path

        expect(response.body).to include(report_filename)
      end
    end

    context "when a non cbd_user is signed in" do
      let(:user) { create(:user, :agency) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions page" do
        get finance_reports_path

        expect(response).to redirect_to("/bo/pages/permission")
        expect(response).to have_http_status(:found)
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get finance_reports_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
