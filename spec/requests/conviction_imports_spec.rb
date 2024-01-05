# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ConvictionImports" do
  describe "GET /bo/import-convictions" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, role: :developer) }

      before do
        sign_in(user)
      end

      it "renders the new template" do
        get "/bo/import-convictions"
        expect(response).to render_template(:new)
      end

      it "returns a 200 response" do
        get "/bo/import-convictions"
        expect(response).to have_http_status(:ok)
      end
    end

    context "when a non-developer user is signed in" do
      let(:user) { create(:user, role: :agency) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/bo/import-convictions"
        expect(response).to redirect_to("/bo/pages/permission")
      end
    end
  end

  describe "POST /bo/import-convictions" do
    let(:valid_csv) { fixture_file_upload(Rails.root.join("spec/fixtures/files/valid_entities.csv"), "text/csv") }
    let(:invalid_csv) { fixture_file_upload(Rails.root.join("spec/fixtures/files/invalid_entities.csv"), "text/csv") }
    let(:invalid_file) { fixture_file_upload(Rails.root.join("spec/fixtures/files/invalid_file.txt"), "text") }

    context "when a valid user is signed in" do
      let(:user) { create(:user, role: :developer) }

      before do
        sign_in(user)
      end

      it "redirects to the results page and displays a flash message" do
        post "/bo/import-convictions", params: { file: valid_csv }

        expect(response).to redirect_to(bo_path)
        expect(flash[:success]).to match(/Convictions data has been updated successfully. \d+ records in database./)
      end

      context "when invalid file type is submitted" do
        it "renders the new template and displays an error message" do
          post "/bo/import-convictions", params: { file: invalid_file }

          expect(response).to render_template(:new)
          expect(flash[:error]).to eq(I18n.t("conviction_imports.flash_messages.invalid_file_type_details"))
        end
      end

      context "when invalid data is submitted" do
        it "renders the new template and displays an error message" do
          post "/bo/import-convictions", params: { file: invalid_csv }

          expect(response).to render_template(:new)
          expect(flash[:error]).to match(/Error occurred while importing data:/)
        end
      end
    end

    context "when a non-developer user is signed in" do
      let(:user) { create(:user, role: :agency) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        post "/bo/import-convictions", params: { file: valid_csv }

        expect(response).to redirect_to("/bo/pages/permission")
      end
    end
  end
end
