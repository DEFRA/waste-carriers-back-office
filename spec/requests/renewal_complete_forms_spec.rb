# frozen_string_literal: true

require "rails_helper"

RSpec.describe "RenewalCompleteForms" do
  let(:transient_registration) { create(:renewing_registration, workflow_state: "renewal_complete_form") }

  let(:path) { "/bo/#{transient_registration.token}/renewal-complete" }

  it_behaves_like "resumes call recording"
end
