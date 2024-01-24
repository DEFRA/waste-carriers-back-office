# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:fix_transient_registrations_with_account_emails", type: :rake do
  let(:task) { Rake::Task["one_off:fix_transient_registrations_with_account_emails"] }

  include_context "rake"

  before do
    task.reenable
  end

  it "runs without error" do
    expect { task.invoke }.not_to raise_error
  end

  context "when a transient registration has accountEmail field present" do
    let(:transient_registration) { create(:renewing_registration, :pending_payment) }

    before do
      WasteCarriersEngine::TransientRegistration.collection.update_one(
        { regIdentifier: transient_registration.regIdentifier },
        { "$set": { accountEmail: "foo@example.com" } }
      )
    end

    it "removes the accountEmail field for the registration" do
      expect(WasteCarriersEngine::TransientRegistration.collection.find({ regIdentifier: transient_registration.regIdentifier, accountEmail: { "$exists": true } }).count).to be_positive
      task.invoke
      expect(WasteCarriersEngine::TransientRegistration.collection.find({ regIdentifier: transient_registration.regIdentifier, accountEmail: { "$exists": true } }).count).to be_zero
    end
  end

  context "when a transient registration doesn't have accountEmail field present" do
    let(:transient_registration) { create(:renewing_registration, :pending_payment) }

    it "does not modify the transient registration" do
      expect { task.invoke }.not_to change(transient_registration, :metaData)
    end
  end

end
