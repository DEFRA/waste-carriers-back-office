# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteCarriersEngine::CompanyPostcodeForm do
  describe "#workflow_state" do
    it_behaves_like "a postcode transition",
                    address_type: "company",
                    factory: :edit_registration
  end
end
