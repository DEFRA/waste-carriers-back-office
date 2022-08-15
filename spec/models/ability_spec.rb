# frozen_string_literal: true

require "cancan/matchers"
require "rails_helper"

RSpec.describe Ability, type: :model do
  let(:role) {}
  let(:deactivated) { false }
  let(:user) { double(:user, role: role, deactivated?: deactivated) }
  subject(:ability) { Ability.new(user) }

  # Agency users have ascending permissions - each tier has the permissions of
  # the previous one, plus additional privileges.

  context "when the user role is agency_super" do
    let(:role) { "agency_super" }

    include_examples "agency_super examples"
    include_examples "agency_with_refund examples"
    include_examples "agency examples"

    include_examples "non-developer examples"
    include_examples "non-import_conviction_data examples"

    include_examples "active and inactive examples"
  end

  context "when the user role is agency_with_refund" do
    let(:role) { "agency_with_refund" }

    include_examples "below agency_super examples"
    include_examples "agency_with_refund examples"
    include_examples "agency examples"

    include_examples "non-developer examples"
    include_examples "non-import_conviction_data examples"

    include_examples "active and inactive examples"
  end

  context "when the user role is agency" do
    let(:role) { "agency" }

    include_examples "below agency_super examples"
    include_examples "below agency_with_refund examples"
    include_examples "agency examples"

    include_examples "non-developer examples"
    include_examples "non-import_conviction_data examples"

    include_examples "active and inactive examples"
  end

  context "when the user role is developer" do
    let(:role) { "developer" }

    include_examples "below agency_super examples"
    include_examples "below agency_with_refund examples"
    include_examples "agency examples"

    include_examples "developer examples"
    include_examples "import_conviction_data examples"

    include_examples "active and inactive examples"
  end

  context "when the user role is import_conviction_data" do
    let(:role) { "import_conviction_data" }

    include_examples "below agency_super examples"
    include_examples "below agency_with_refund examples"
    include_examples "agency examples"

    include_examples "non-developer examples"
    include_examples "import_conviction_data examples"

    include_examples "active and inactive examples"
  end

  # Finance users do not have ascending permissions.

  context "when the user role is finance_super" do
    let(:role) { "finance_super" }

    include_examples "finance_super examples"
    include_examples "finance_admin examples"

    include_examples "non-developer examples"
    include_examples "non-import_conviction_data examples"

    include_examples "active and inactive examples"
  end

  context "when the user role is finance_admin" do
    let(:role) { "finance_admin" }

    include_examples "below finance_super examples"
    include_examples "finance_admin examples"

    include_examples "non-developer examples"
    include_examples "non-import_conviction_data examples"

    include_examples "active and inactive examples"
  end

  context "when the user role is finance" do
    let(:role) { "finance" }

    include_examples "finance examples"

    include_examples "non-developer examples"
    include_examples "non-import_conviction_data examples"

    include_examples "active and inactive examples"
  end

  context "when the user role is data_agent" do
    let(:role) { "data_agent" }

    include_examples "data_agent examples"

    include_examples "non-developer examples"
    include_examples "non-import_conviction_data examples"
    include_examples "active and inactive examples"
  end
end
