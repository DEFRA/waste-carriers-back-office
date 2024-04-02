# frozen_string_literal: true

require "rails_helper"
module WasteCarriersEngine
  # This service is tested in the engine, but we test it here also to ensure
  # that when invoked from the back-office it generates a front-office link
  RSpec.describe UnsubscribeLinkService do

    subject(:run_service) { described_class.run(registration: registration) }

    let(:registration) { create(:registration) }

    describe "run" do
      before { @unsubscribe_link = run_service }

      it "returns a link to the front office" do
        expect(@unsubscribe_link).to start_with(Rails.configuration.wcrs_fo_link_domain)
      end

      it "does not include the back-office path prefix" do
        expect(@unsubscribe_link).not_to match(%r{/bo/unsubscribe})
      end
    end
  end
end
