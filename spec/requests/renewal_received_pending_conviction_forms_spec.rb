# frozen_string_literal: true

require "rails_helper"

RSpec.describe "RenewalReceivedPendingConvictionForms" do
  let(:transient_registration) { create(:new_registration, :has_required_data, workflow_state: "renewal_received_pending_conviction_form") }

  let(:path) { "/bo/#{transient_registration.token}/renewal-received" }

  it_behaves_like "a controller that resumes call recording"
end
