# frozen_string_literal: true

require "rails_helper"

RSpec.describe "RenewalReceivedPendingConvictionForms" do
  let(:user) { create(:user, role: :agency_super) }
  let(:transient_registration) { create(:new_registration, :has_required_data, workflow_state: "renewal_received_pending_conviction_form") }

  let(:path) { "/bo/#{transient_registration.token}/renewal-received" }

  before { sign_in(user) }

  it "returns http success" do
    get path

    expect(response).to have_http_status(:success)
  end
end
