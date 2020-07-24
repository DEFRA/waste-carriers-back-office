# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Digital Reminder letters export", type: :request do
  let(:user) { create(:user, :agency) }

  before(:each) do
    sign_in(user)
  end

  describe "GET /digital-reminder-letters-exports" do
    it "renders the correct template and responds with a 200 status code" do
      get digital_reminder_letters_exports_path

      expect(response).to render_template("digital_reminder_letters_exports/index")
      expect(response.code).to eq("200")
    end
  end

  describe "PUT /digital-reminder-letters-exports" do
    let(:digital_reminder_letters_export) { create(:digital_reminder_letters_export) }
    let(:params) do
      {
        digital_reminder_letters_export: {
          printed_on: Date.today,
          printed_by: user.email
        }
      }
    end

    it "update the record and redirects to the index path" do
      put digital_reminder_letters_export_path(digital_reminder_letters_export), params: params

      digital_reminder_letters_export.reload

      expect(digital_reminder_letters_export.printed_on).to eq(Date.today)
      expect(digital_reminder_letters_export.printed_by).to eq(user.email)
      expect(response).to redirect_to(digital_reminder_letters_exports_path)
    end
  end
end
