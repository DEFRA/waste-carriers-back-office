# frozen_string_literal: true

require "cancan/matchers"
require "rails_helper"

RSpec.describe Ability, type: :model do
  let(:role) {}
  let(:user) { double(:user, role: role) }
  subject(:ability) { Ability.new(user) }

  # Agency users have ascending permissions - each tier has the permissions of
  # the previous one, plus additional privileges.

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

  # Finance users do not have ascending permissions.

  context "when the user role is finance_super" do
    let(:role) { "finance_super" }

    include_examples "finance_super examples"
  end

  context "when the user role is finance_admin" do
    let(:role) { "finance_admin" }

    include_examples "finance_admin examples"
  end

  context "when the user role is finance" do
    let(:role) { "finance" }

    include_examples "finance examples"
  end
end
