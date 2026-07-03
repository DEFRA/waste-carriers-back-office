# frozen_string_literal: true

require "rails_helper"

RSpec.describe DeregistrationTokenCleanupService do
  describe ".run" do
    let!(:registration) { create(:registration) }
    let(:collection) { WasteCarriersEngine::Registration.collection }

    def stored_document
      collection.find("_id" => registration.id).first
    end

    def set_legacy_fields(fields)
      collection.update_one({ "_id" => registration.id }, { "$set" => fields })
    end

    context "when a registration has both obsolete deregistration fields" do
      before do
        set_legacy_fields("deregistration_token" => "TOKEN", "deregistration_token_created_at" => Time.zone.now)
      end

      it "removes deregistration_token" do
        expect { described_class.run }.to change { stored_document["deregistration_token"] }.from("TOKEN").to(nil)
      end

      it "removes deregistration_token_created_at" do
        described_class.run

        expect(stored_document["deregistration_token_created_at"]).to be_nil
      end

      it "is idempotent on a second run" do
        described_class.run

        expect { described_class.run }.not_to raise_error
        expect(stored_document["deregistration_token"]).to be_nil
      end
    end

    context "when a registration has only one of the obsolete fields" do
      before { set_legacy_fields("deregistration_token" => "TOKEN") }

      it "still removes it" do
        expect { described_class.run }.to change { stored_document["deregistration_token"] }.from("TOKEN").to(nil)
      end
    end

    context "when a registration has none of the obsolete fields" do
      it "leaves the registration untouched" do
        described_class.run

        expect(stored_document).to be_present
        expect(stored_document["deregistration_token"]).to be_nil
      end
    end
  end
end
