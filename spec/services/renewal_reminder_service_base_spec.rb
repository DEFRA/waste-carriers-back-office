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
      expiring = create(:registration, expires_on: 3.days.from_now)
      not_exiring = create(:registration, expires_on: 5.days.from_now)
      expiring_too_soon = create(:registration, expires_on: 2.days.from_now)
      ad_contact_email = create(
        :registration,
        expires_on: 3.days.from_now,
        contact_email: "nccc-carrierbroker@environment-agency.gov.uk"
      )
      empty_contact_email = create(:registration, expires_on: 3.days.from_now, contact_email: nil)

      expect_any_instance_of(TestRegistrationTransferService).to receive(:send_email).with(expiring)

      expect_any_instance_of(TestRegistrationTransferService).to_not receive(:send_email).with(not_exiring)
      expect_any_instance_of(TestRegistrationTransferService).to_not receive(:send_email).with(expiring_too_soon)
      expect_any_instance_of(TestRegistrationTransferService).to_not receive(:send_email).with(ad_contact_email)
      expect_any_instance_of(TestRegistrationTransferService).to_not receive(:send_email).with(empty_contact_email)

      TestRegistrationTransferService.run
    end
  end
end
