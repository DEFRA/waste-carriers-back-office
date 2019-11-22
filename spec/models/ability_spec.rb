# frozen_string_literal: true

require "cancan/matchers"
require "rails_helper"

RSpec.describe Ability, type: :model do
  let(:role) {}
  let(:user) { create(:user, role: role) }
  subject(:ability) { Ability.new(user) }

  let(:registration) do
    create(:registration)
  end
  let(:transient_registration) do
    create(:renewing_registration)
  end

  context "when the user role is agency_super" do
    let(:role) { "agency_super" }

    include_examples "agency_super examples"
    include_examples "agency_with_refund examples"
    include_examples "agency examples"
  end

  context "when the user role is agency_with_refund" do
    let(:role) { "agency_with_refund" }

    include_examples "below agency_super examples"
    include_examples "agency_with_refund examples"
    include_examples "agency examples"
  end

  context "when the user role is agency" do
    let(:role) { "agency" }

    include_examples "below agency_super examples"
    include_examples "below agency_with_refund examples"
    include_examples "agency examples"
  end
end
