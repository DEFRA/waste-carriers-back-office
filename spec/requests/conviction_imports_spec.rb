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
    let(:csv_with_blank_header) { fixture_file_upload(Rails.root.join("spec/fixtures/files/blank_header.csv"), "text/csv") }
    let(:extra_headers_csv) { fixture_file_upload(Rails.root.join("spec/fixtures/files/extra_headers.csv"), "text/csv") }
    let(:mixed_order_headers_csv) { fixture_file_upload(Rails.root.join("spec/fixtures/files/mixed_order_headers.csv"), "text/csv") }
    let(:csv_missing_required_headers) { fixture_file_upload(Rails.root.join("spec/fixtures/files/missing_required_headers.csv"), "text/csv") }

    context "when a valid user is signed in" do
      let(:user) { create(:user, role: :developer) }

      before do
        sign_in(user)
      end

      context "when the CSV file is as expected" do
        it "redirects to the results page and displays a flash message" do
          post "/bo/import-convictions", params: { file: valid_csv }

          expect(response).to redirect_to(bo_path)
          expect(flash[:success]).to match(/Convictions data has been updated successfully. \d+ records in database./)
        end
      end

      describe "utf-8 encoding" do
        let(:empty_utf_8_csv) { fixture_file_upload(Rails.root.join("spec/fixtures/files/utf-8.csv"), "text/csv") }
        let(:empty_non_utf_8_csv) { fixture_file_upload(Rails.root.join("spec/fixtures/files/non-utf-8.csv"), "text/csv") }
        let(:utf_8_csv_with_data) { fixture_file_upload(Rails.root.join("spec/fixtures/files/utf-8-with-data.csv"), "text/csv") }
        let(:utf_8_csv_with_data_and_bom) { fixture_file_upload(Rails.root.join("spec/fixtures/files/valid_entities-utf8.csv"), "text/csv") }

        context "with a file with only headers" do
          context "when the file is utf-8 encoded" do
            it "redirects to the results page and displays a flash message" do
              post "/bo/import-convictions", params: { file: empty_utf_8_csv }

              expect(response).to render_template(:new)
              expect(flash[:error]).to eq("Error occurred while importing data: No valid convictions found in the file. Please check the file and try again.")
            end
          end

          context "when the file is not utf-8 encoded" do
            it "redirects to the results page and displays a flash message" do
              post "/bo/import-convictions", params: { file: empty_non_utf_8_csv }

              expect(response).to render_template(:new)
              expect(flash[:error]).to eq("Error occurred while importing data: No valid convictions found in the file. Please check the file and try again.")
            end
          end
        end

        context "with a file with data" do
          context "when the file is utf-8 encoded" do
            it "redirects to the results page and displays a flash message" do
              post "/bo/import-convictions", params: { file: utf_8_csv_with_data }

              expect(response).to redirect_to(bo_path)
              expect(flash[:success]).to match(/Convictions data has been updated successfully. 1 record in database./)
            end

            context "when the file starts with a BOM in front of a required field" do

              it "redirects to the results page and displays a flash message" do
                post "/bo/import-convictions", params: { file: utf_8_csv_with_data_and_bom }

                expect(response).to redirect_to(bo_path)
                expect(flash[:success]).to match(/Convictions data has been updated successfully. \d+ records in database./)
              end
            end
          end
        end
      end

      context "when the CSV file has some blank headers" do
        it "redirects to the results page and displays a flash message" do
          post "/bo/import-convictions", params: { file: csv_with_blank_header }

          expect(response).to redirect_to(bo_path)
          expect(flash[:success]).to match(/Convictions data has been updated successfully. \d+ records in database./)
        end
      end

      context "when the CSV file has extra headers" do
        it "redirects to the results page and displays a flash message" do
          post "/bo/import-convictions", params: { file: extra_headers_csv }

          expect(response).to redirect_to(bo_path)
          expect(flash[:success]).to match(/Convictions data has been updated successfully. \d+ records in database./)
        end
      end

      context "when the CSV file has headers in mixed order" do
        it "redirects to the results page and displays a flash message" do
          post "/bo/import-convictions", params: { file: mixed_order_headers_csv }

          expect(response).to redirect_to(bo_path)
          expect(flash[:success]).to match(/Convictions data has been updated successfully. \d+ records in database./)
        end
      end

      context "when a required header is missing" do
        it "renders the new template and displays an error message" do
          post "/bo/import-convictions", params: { file: csv_missing_required_headers }

          expect(response).to render_template(:new)
          expect(flash[:error]).to match(/Error occurred while importing data:/)
        end
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
