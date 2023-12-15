# frozen_string_literal: true

require "rails_helper"

RSpec.describe "RegistrationReceivedPendingConvictionForms" do
  let(:transient_registration) { create(:new_registration, :has_required_data, workflow_state: "registration_received_pending_conviction_form") }
  let(:path) { "/bo/#{transient_registration.token}/registration-received" }

  it_behaves_like "resumes call recording"
end
