# frozen_string_literal: true

require "rails_helper"
require "support/shared_examples/call_recording_resumption"

RSpec.describe "Copy cards order completed form" do
  describe "/bo/order-copy-cards-completed/:token" do
    let(:transient_registration) do
      create(:renewing_registration, finance_details: build(:finance_details, :has_paid_order_and_payment), workflow_state: "copy_cards_order_completed_form")
    end
    let(:path) { "/bo/#{transient_registration.token}/order-copy-cards-complete" }

    it_behaves_like "a controller that resumes call recording"
  end
end
