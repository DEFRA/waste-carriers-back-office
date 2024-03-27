# frozen_string_literal: true

require "rails_helper"

RSpec.describe RenewalReminderServiceBase do

  let(:test_class) do
    Class.new(described_class) do
      def expires_in_days = 3
    end
  end

  describe ".run" do
    let(:test_class_instance) { test_class.new }

    before do
      allow(test_class).to receive(:new).and_return(test_class_instance)
      allow(test_class_instance).to receive(:send_email).and_call_original
    end

    it "send emails to relevant registrations" do
      expiring = create(:registration, expires_on: 3.days.from_now)
      not_expiring = create(:registration, expires_on: 5.days.from_now)
      expiring_too_soon = create(:registration, expires_on: 2.days.from_now)
      ad_registration = create(
        :registration,
        expires_on: 3.days.from_now,
        contact_email: nil
      )
      empty_contact_email = create(:registration, expires_on: 3.days.from_now, contact_email: "")
      nil_contact_email = create(:registration, expires_on: 3.days.from_now, contact_email: nil)
      opted_out_registration = create(:registration, expires_on: 3.days.from_now, communications_opted_in: false)

      test_class.run

      aggregate_failures do
        expect(test_class_instance).to have_received(:send_email).with(expiring)

        expect(test_class_instance).not_to have_received(:send_email).with(not_expiring)
        expect(test_class_instance).not_to have_received(:send_email).with(expiring_too_soon)
        expect(test_class_instance).not_to have_received(:send_email).with(ad_registration)
        expect(test_class_instance).not_to have_received(:send_email).with(empty_contact_email)
        expect(test_class_instance).not_to have_received(:send_email).with(nil_contact_email)
        expect(test_class_instance).not_to have_received(:send_email).with(opted_out_registration)
      end
    end

    context "when an error occurs" do
      before do
        create(:registration, expires_on: 3.days.from_now)

        allow(test_class_instance).to receive(:send_email).and_raise("error")
        allow(Airbrake).to receive(:notify)
        allow(Rails.logger).to receive(:error)

        test_class.run
      end

      it { expect(Airbrake).to have_received(:notify) }
      it { expect(Rails.logger).to have_received(:error) }
    end
  end
end
