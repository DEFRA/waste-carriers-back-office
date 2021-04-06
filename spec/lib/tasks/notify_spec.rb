# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Notify task", type: :rake do
  include_context "rake"

  describe "notify:letters:ad_renewals" do
    it "runs without error" do
      expect(NotifyBulkAdRenewalLettersService).to receive(:run).and_return([build(:registration)])
      expect { subject.invoke }.not_to raise_error
    end
  end

  describe "notify:letters:digital_renewals" do
    it "runs without error" do
      expect(NotifyBulkDigitalRenewalLettersService).to receive(:run).and_return([build(:registration)])
      expect { subject.invoke }.not_to raise_error
    end
  end

  describe "notify:test:ad_renewal_letter" do
    it "runs without error" do
      expect(NotifyAdRenewalLetterService).to receive(:run)
      expect { subject.invoke }.not_to raise_error
    end
  end

  describe "notify:test:digital_renewal_letter" do
    it "runs without error" do
      expect(NotifyDigitalRenewalLetterService).to receive(:run)
      expect { subject.invoke }.not_to raise_error
    end
  end
end
