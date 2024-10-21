# frozen_string_literal: true

require "rails_helper"

module WasteCarriersEngine
  RSpec.describe NewRegistration do
    subject(:new_registration) { build(:new_registration) }

    describe "scopes" do
      it_behaves_like "TransientRegistration named scopes"
    end
  end
end
