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
    let(:params) do
      {
        data: %(
Offender,Birth Date,Company No.,System Flag,Inc Number
Apex Limited,,11111111,ABC,99999999
"Doe, John",01/01/1991,,DFG,
   Whitespace Inc   , , , ,
)
      }
    end

    context "when a valid user is signed in" do
      let(:user) { create(:user, role: :developer) }

      before do
        sign_in(user)
      end

      it "redirects to the results page and displays a flash message" do
        post "/bo/import-convictions", params: params

        expect(response).to redirect_to("/bo")
        expect(request.flash[:success]).to eq("Convictions data has been updated successfully. 3 records in database.")
      end

      context "when invalid data is submitted" do
        let(:params) { { data: "foo" } }

        it "redirects to the :new template and displays an error message" do
          post "/bo/import-convictions", params: params

          expect(response).to render_template(:new)
          expect(request.flash[:error]).to eq("Error occurred while importing data: Invalid headers")
        end
      end
    end

    context "when a non-developer user is signed in" do
      let(:user) { create(:user, role: :agency) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        post "/bo/import-convictions", params: params

        expect(response).to redirect_to("/bo/pages/permission")
      end
    end
  end
end
