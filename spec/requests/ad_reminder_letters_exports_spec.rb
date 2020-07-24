# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Ad Reminder letters export", type: :request do
  let(:user) { create(:user, :agency) }

  before(:each) do
    sign_in(user)
  end

  describe "GET /ad-reminder-letters-exports" do
    it "renders the correct template and responds with a 200 status code" do
      get ad_reminder_letters_exports_path

      expect(response).to render_template("ad_reminder_letters_exports/index")
      expect(response.code).to eq("200")
    end
  end

  describe "PUT /ad-reminder-letters-exports" do
    let(:ad_reminder_letters_export) { create(:ad_reminder_letters_export) }
    let(:params) do
      {
        ad_reminder_letters_export: {
          printed_on: Date.today,
          printed_by: user.email
        }
      }
    end

    it "update the record and redirects to the index path" do
      put ad_reminder_letters_export_path(ad_reminder_letters_export), params: params

      ad_reminder_letters_export.reload

      expect(ad_reminder_letters_export.printed_on).to eq(Date.today)
      expect(ad_reminder_letters_export.printed_by).to eq(user.email)
      expect(response).to redirect_to(ad_reminder_letters_exports_path)
    end
  end
end
