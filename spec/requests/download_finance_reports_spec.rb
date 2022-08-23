# frozen_string_literal: true

require "rails_helper"

RSpec.describe "DownloadFinanceReports", type: :request do

  # for checking tmp dirs before and after tests, to support tmp file cleanup
  def tmp_dirs
    Dir[File.join(Pathname.new(Dir.mktmpdir).dirname, "*")]
  end

  describe "GET /bo/card_order_exports" do

    context "when a cbd_user is signed in" do
      let(:user) { create(:user, :cbd_user) }

      before(:each) do
        @tmp_dirs_pre = tmp_dirs
        sign_in(user)
        get finance_reports_path
      end

      # Clean up the test /tmp area after generating the files
      after(:each) do
        tmp_dirs_added = tmp_dirs - @tmp_dirs_pre
        tmp_dirs_added.each { |tmp_dir| FileUtils.rm_rf(tmp_dir) }
      end

      it "returns HTTP status 200" do
        expect(response).to have_http_status(200)
      end

    end

    context "when a non cbd_user is signed in" do
      let(:user) { create(:user, :agency) }

      before(:each) do
        sign_in(user)
      end

      it "redirects to the permissions page" do
        get finance_reports_path

        expect(response).to redirect_to("/bo/pages/permission")
        expect(response).to have_http_status(302)
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
