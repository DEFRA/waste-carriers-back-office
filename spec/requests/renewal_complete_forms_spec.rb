# frozen_string_literal: true

require "rails_helper"

RSpec.describe "RenewalCompleteForms" do
  let(:user) { create(:user, role: :agency_super) }
  let(:transient_registration) { create(:renewing_registration, workflow_state: "renewal_complete_form") }

  let(:path) { "/bo/#{transient_registration.token}/renewal-complete" }

  before { sign_in(user) }

  it "returns http success" do
    get path

    expect(response).to have_http_status(:success)
  end
end
