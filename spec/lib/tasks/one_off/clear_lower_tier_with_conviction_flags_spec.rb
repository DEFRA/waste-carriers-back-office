# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:clear_lower_tier_with_conviction_flags", type: :task do
  let(:task) { Rake::Task["one_off:clear_lower_tier_with_conviction_flags"] }

  include_context "rake"

  before do
    task.reenable
  end

  it "runs without error" do
    expect { task.invoke }.not_to raise_error
  end

  context "when a LOWER tier registration has a conviction sign off" do
    let!(:registration) { create(:registration, :requires_conviction_check, tier: "LOWER") }

    it "clears the conviction sign off for the registration" do
      task.invoke
      registration.reload
      expect(registration.conviction_sign_offs).to be_empty
    end
  end

  context "when a LOWER tier registration doesn't have a conviction sign off" do
    let!(:registration) { create(:registration, tier: "LOWER") }

    it "does not modify the registration" do
      expect { task.invoke }.not_to change(registration, :conviction_sign_offs)
    end
  end

  context "when a registration of a different tier has a conviction sign off" do
    let!(:registration) { create(:registration, :requires_conviction_check, tier: "UPPER") }

    it "does not clear the conviction sign off for the registration" do
      task.invoke
      registration.reload
      expect(registration.conviction_sign_offs).not_to be_empty
    end
  end
end
