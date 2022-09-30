# frozen_string_literal: true

require "rails_helper"

RSpec.describe RenewalReminderServiceBase do

  let(:test_class) do
    Class.new(described_class) do
      def expires_in_days; 3; end
      def send_email(_arg); end  
    end
  end

  describe ".run" do
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

      expect_any_instance_of(test_class).to receive(:send_email).with(expiring)

      expect_any_instance_of(test_class).to_not receive(:send_email).with(not_expiring)
      expect_any_instance_of(test_class).to_not receive(:send_email).with(expiring_too_soon)
      expect_any_instance_of(test_class).to_not receive(:send_email).with(ad_registration)
      expect_any_instance_of(test_class).to_not receive(:send_email).with(empty_contact_email)
      expect_any_instance_of(test_class).to_not receive(:send_email).with(nil_contact_email)

      test_class.run
    end

    context "when an error occurs" do
      it "logs it in rails and send it to Airbrake" do
        create(:registration, expires_on: 3.days.from_now)

        expect_any_instance_of(test_class).to receive(:send_email).and_raise("error")

        expect(Airbrake).to receive(:notify)
        expect(Rails.logger).to receive(:error)

        test_class.run
      end
    end
  end
end
