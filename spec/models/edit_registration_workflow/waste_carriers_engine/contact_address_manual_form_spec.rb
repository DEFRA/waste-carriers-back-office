# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteCarriersEngine::ContactAddressManualForm do
  describe "#workflow_state" do
    it_behaves_like "a manual address transition",
                    next_state: :edit_form,
                    address_type: "contact",
                    factory: :edit_registration
  end
end
