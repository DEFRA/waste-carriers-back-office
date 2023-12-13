# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteCarriersEngine::ContactPostcodeForm do
  describe "#workflow_state" do
    it_behaves_like "a postcode transition",
                    address_type: "contact",
                    factory: :edit_registration
  end
end
