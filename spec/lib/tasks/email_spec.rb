# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Email task", type: :task do
  include_context "rake"

  let(:registrations_count) { 1 }

  before do
    allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).and_call_original
    allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:renewal_reminders).and_return(true)
    allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:service_closure).and_return(false)
  end

  context "when service closure is enabled" do
    before do
      allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:service_closure).and_return(true)
    end

    describe "email:renew_reminder:first:send" do
      it "does not send reminders" do
        expect(FirstRenewalReminderService).not_to receive(:run)
        Rake::Task["email:renew_reminder:first:send"].invoke
      end
    end

    describe "email:renew_reminder:second:send" do
      it "does not send reminders" do
        expect(SecondRenewalReminderService).not_to receive(:run)
        Rake::Task["email:renew_reminder:second:send"].invoke
      end
    end
  end

  describe "email:renew_reminder:first:send" do
    before do
      allow(FirstRenewalReminderService).to receive(:run).and_return(registrations_count)
      subject.reenable
    end

    it "runs without error" do
      expect { subject.invoke }.not_to raise_error
    end

    it "logs the number of emails sent" do
      expect(StdoutLogger).to receive(:log).with("Sent #{registrations_count} first renewal reminder(s)")
      subject.invoke
    end
  end

  describe "email:renew_reminder:second:send" do
    before do
      allow(SecondRenewalReminderService).to receive(:run).and_return(registrations_count)
      subject.reenable
    end

    it "runs without error" do
      expect { subject.invoke }.not_to raise_error
    end

    it "logs the number of emails sent" do
      expect(StdoutLogger).to receive(:log).with("Sent #{registrations_count} second renewal reminder(s)")
      subject.invoke
    end
  end
end
