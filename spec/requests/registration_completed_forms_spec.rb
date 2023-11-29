# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Registration completed form" do
  describe "/bo/registration-completed/:token" do
    let(:transient_registration) { create(:new_registration, :has_required_data, workflow_state: "registration_completed_form") }
    let(:path) { "/bo/#{transient_registration.token}/registration-completed" }

    it_behaves_like "a controller that resumes call recording"
  end
end
