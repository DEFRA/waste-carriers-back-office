# frozen_string_literal: true

require "rails_helper"

RSpec.describe "RegistrationReceivedPendingConvictionForms" do
  let(:user) { create(:user, role: :agency_super) }
  let(:transient_registration) { create(:new_registration, :has_required_data, workflow_state: "registration_received_pending_conviction_form") }
  let(:path) { "/bo/#{transient_registration.token}/registration-received" }

  before { sign_in(user) }

  it "returns http success" do
    get path

    expect(response).to have_http_status(:success)
  end
end
