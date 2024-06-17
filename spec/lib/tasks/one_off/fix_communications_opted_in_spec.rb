# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:fix_communications_opted_in", type: :task do
  let(:task) { Rake::Task["one_off:fix_communications_opted_in"] }

  include_context "rake"

  before do
    task.reenable
  end

  it "runs without error" do
    expect { task.invoke }.not_to raise_error
  end

  context "when a registration has no communications_opted_in field set" do
    let!(:upper_tier_registration) { create(:registration, tier: "UPPER") }
    let!(:lower_tier_registration) { create(:registration, tier: "LOWER") }
    let!(:inactive_registration) { create(:registration, tier: "UPPER", metaData: { status: "PENDING" }) }

    before do
      WasteCarriersEngine::Registration.collection.update_many({}, { "$unset": { communications_opted_in: 1 } })
    end

    it "set communications_opted_in to true for active upper tier registrations" do
      expect(WasteCarriersEngine::Registration.collection.find({ regIdentifier: upper_tier_registration.regIdentifier, communications_opted_in: true }).count).to be_zero
      task.invoke
      expect(WasteCarriersEngine::Registration.collection.find({ regIdentifier: upper_tier_registration.regIdentifier, communications_opted_in: true }).count).to be_positive
    end

    it "does not modify the lower tier registrations" do
      expect { task.invoke }.not_to change(lower_tier_registration, :communications_opted_in)
    end

    it "does not modify the inactive registrations" do
      expect { task.invoke }.not_to change(inactive_registration, :communications_opted_in)
    end
  end

  context "when a registration has communications_opted_in field set already" do
    let(:registration) { create(:registration, communications_opted_in: false) }

    it "does not modify the registration" do
      expect { task.invoke }.not_to change(registration, :communications_opted_in)
    end
  end
end
