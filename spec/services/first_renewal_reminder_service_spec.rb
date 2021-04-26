# frozen_string_literal: true

require "rails_helper"

RSpec.describe FirstRenewalReminderService do
  let!(:registration) do
    create(:registration, :active, expires_on: 42.days.from_now)
  end

  describe ".run" do
    subject { described_class.run }

    it "calls the notify renewal reminder email service" do
      expect(Notify::RenewalReminderEmailService)
        .to receive(:run)
        .with(registration: registration)
        .once

      subject
    end

    context "when that service fails" do
      it "notifies Airbrake" do
        the_error = StandardError.new("Oopss!")

        allow(Notify::RenewalReminderEmailService)
          .to receive(:run)
          .and_raise(the_error)

        expect(Airbrake)
          .to receive(:notify)
          .with(the_error, { registration_no: registration.reg_identifier })

        subject
      end
    end
  end
end
