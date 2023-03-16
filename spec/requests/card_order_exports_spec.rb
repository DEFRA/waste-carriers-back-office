# frozen_string_literal: true

require "rails_helper"

RSpec.describe "CardOrderExports" do

  describe "GET /bo/card_order_exports" do
    before { create_list(:card_orders_export_log, 5) }

    context "when an agency-with-refund user is signed in" do
      let(:user) { create(:user, role: :agency_with_refund) }

      before do
        sign_in(user)
        get card_order_exports_path
      end

      it "returns HTTP status 200" do
        expect(response).to have_http_status(:ok)
      end

      it "presents the latest export date and time" do
        last_exported_at = CardOrdersExportLog.last.exported_at.strftime("%Y-%m-%d %H:%M")
        expect(response.body).to match(/The latest file was created at #{last_exported_at}/)
      end

      it "presents all card order exports" do
        expect(response.body.scan(%r{#{card_order_exports_path}/\w+}).size).to eq 5
      end
    end

    context "when a non agency-with-refund user is signed in" do
      let(:user) { create(:user, role: :agency) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions page" do
        get card_order_exports_path

        expect(response).to redirect_to("/bo/pages/permission")
        expect(response).to have_http_status(:found)
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get card_order_exports_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /bo/card_order_exports/:id" do
    let(:user) { create(:user, role: :agency_with_refund) }
    let(:export_log) { create(:card_orders_export_log) }

    context "when it is the first visit" do

      before do
        sign_in(user)
        get card_order_export_path(export_log.id)
      end

      it "logs the visit to the export file" do
        export_log = CardOrdersExportLog.first
        expect(export_log.first_visited_by).to eq user.email
        expect(export_log.first_visited_at).to be_within(1.second).of(DateTime.now)
      end

      it "redirects the user to the AWS S3 download link" do
        expect(response).to have_http_status(:found)
        # Match against location instead of expect redirect_to in order to exclude
        # variable "X-Amz-"" parameters from the comparison.
        expected_redirect_url = CardOrdersExportLog.first.download_link.split("&X-Amz")[0]
        expect(response.location).to start_with(expected_redirect_url)
      end
    end

    context "when it is the second visit" do
      let(:first_user) { build(:user, role: :agency_with_refund) }
      let(:second_user) { build(:user, role: :agency_with_refund) }

      before do
        sign_in(first_user)
        get card_order_export_path(export_log.id)
        sign_in(second_user)
      end

      it "does not update the first visit user" do
        expect { get card_order_export_path(export_log.id) }.not_to change { export_log.reload.first_visited_by }.from(first_user.email)
      end

      it "does not update the first visit time" do
        expect { get card_order_export_path(export_log.id) }.not_to change(export_log, :first_visited_at)
      end
    end
  end
end
