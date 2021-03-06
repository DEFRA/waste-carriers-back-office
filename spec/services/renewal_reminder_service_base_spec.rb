# frozen_string_literal: true

require "rails_helper"

RSpec.describe RenewalReminderServiceBase do
  class TestRegistrationTransferService < RenewalReminderServiceBase
    def expires_in_days
      3
    end

    def send_email(_arg); end
  end

  describe ".run" do
    it "send emails to relevant registrations" do
      ad_contact_email = WasteCarriersEngine.configuration.assisted_digital_email
      expiring = create(:registration, expires_on: 3.days.from_now)
      not_expiring = create(:registration, expires_on: 5.days.from_now)
      expiring_too_soon = create(:registration, expires_on: 2.days.from_now)
      ad_contact_email = create(
        :registration,
        expires_on: 3.days.from_now,
        contact_email: ad_contact_email
      )
      empty_contact_email = create(:registration, expires_on: 3.days.from_now, contact_email: "")
      nil_contact_email = create(:registration, expires_on: 3.days.from_now, contact_email: nil)

      expect_any_instance_of(TestRegistrationTransferService).to receive(:send_email).with(expiring)

      expect_any_instance_of(TestRegistrationTransferService).to_not receive(:send_email).with(not_expiring)
      expect_any_instance_of(TestRegistrationTransferService).to_not receive(:send_email).with(expiring_too_soon)
      expect_any_instance_of(TestRegistrationTransferService).to_not receive(:send_email).with(ad_contact_email)
      expect_any_instance_of(TestRegistrationTransferService).to_not receive(:send_email).with(empty_contact_email)
      expect_any_instance_of(TestRegistrationTransferService).to_not receive(:send_email).with(nil_contact_email)

      TestRegistrationTransferService.run
    end

    context "when an error occurs" do
      it "logs it in rails and send it to Airbrake" do
        create(:registration, expires_on: 3.days.from_now)

        expect_any_instance_of(TestRegistrationTransferService).to receive(:send_email).and_raise("error")

        expect(Airbrake).to receive(:notify)
        expect(Rails.logger).to receive(:error)

        TestRegistrationTransferService.run
      end
    end
  end
end
