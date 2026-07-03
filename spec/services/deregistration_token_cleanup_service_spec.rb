# frozen_string_literal: true

require "rails_helper"

RSpec.describe DeregistrationTokenCleanupService do
  describe ".run" do
    let(:registration) { create(:registration) }
    let(:collection) { WasteCarriersEngine::Registration.collection }

    def stored_document
      collection.find("_id" => registration.id).first
    end

    context "when a registration still has the obsolete deregistration fields" do
      before do
        collection.update_one(
          { "_id" => registration.id },
          { "$set" => { "deregistration_token" => "TOKEN", "deregistration_token_created_at" => Time.zone.now } }
        )
      end

      it "removes deregistration_token" do
        expect { described_class.run }.to change { stored_document["deregistration_token"] }.from("TOKEN").to(nil)
      end

      it "removes deregistration_token_created_at" do
        described_class.run

        expect(stored_document["deregistration_token_created_at"]).to be_nil
      end
    end

    context "when a registration does not have the obsolete fields" do
      it "does not raise and leaves the registration in place" do
        expect { described_class.run }.not_to raise_error
        expect(stored_document).to be_present
      end
    end
  end
end
