# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteCarriersEngine::ContactAddressForm do
  describe "#workflow_state" do
    it_behaves_like "an address lookup transition",
                    next_state_if_not_skipping_to_manual: :edit_form,
                    address_type: "company",
                    factory: :edit_registration
  end
end
