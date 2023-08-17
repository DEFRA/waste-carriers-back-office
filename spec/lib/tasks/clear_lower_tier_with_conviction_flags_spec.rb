# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:clear_lower_tier_with_conviction_flags", type: :rake do
  include_context "rake"

  before do
    Rake::Task["one_off:clear_lower_tier_with_conviction_flags"].reenable
  end

  it "runs without error" do
    expect { subject.invoke }.not_to raise_error
  end

  context "when a LOWER tier registration has a conviction sign off" do
    let!(:registration) { create(:registration, tier: "LOWER", conviction_sign_off: build(:conviction_sign_off)) }

    it "clears the conviction sign off for the registration" do
      subject.invoke
      registration.reload
      expect(registration.conviction_sign_off).to be_nil
    end
  end

  context "when a LOWER tier registration doesn't have a conviction sign off" do
    let!(:registration) { create(:registration, tier: "LOWER") }

    it "does not modify the registration" do
      expect { subject.invoke }.not_to change { registration.reload.updated_at }
    end
  end

  context "when a registration of a different tier has a conviction sign off" do
    let!(:registration) { create(:registration, tier: "UPPER", conviction_sign_off: build(:conviction_sign_off)) }

    it "does not clear the conviction sign off for the registration" do
      subject.invoke
      registration.reload
      expect(registration.conviction_sign_off).not_to be_nil
    end
  end
end

