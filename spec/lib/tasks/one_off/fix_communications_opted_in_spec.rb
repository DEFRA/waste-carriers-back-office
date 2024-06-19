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
    let!(:registration) { create(:registration, expires_on: 2.days.from_now) }

    before do
      WasteCarriersEngine::Registration.collection.update_one(
        { regIdentifier: registration.regIdentifier },
        { "$unset": { communications_opted_in: 1 } }
      )
    end

    it "set communications_opted_in to true" do
      expect(WasteCarriersEngine::Registration.collection.find({ regIdentifier: registration.regIdentifier, communications_opted_in: true }).count).to be_zero
      task.invoke
      expect(WasteCarriersEngine::Registration.collection.find({ regIdentifier: registration.regIdentifier, communications_opted_in: true }).count).to be_positive
    end
  end

  context "when a registration has communications_opted_in field set already" do
    let(:registration) { create(:registration, communications_opted_in: false, expires_on: 2.days.from_now) }

    it "does not modify the registration" do
      expect { task.invoke }.not_to change(registration, :communications_opted_in)
    end
  end
end
