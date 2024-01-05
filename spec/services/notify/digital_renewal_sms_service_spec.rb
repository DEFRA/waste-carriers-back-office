# frozen_string_literal: true

require "rails_helper"

RSpec.describe Notify::DigitalRenewalSmsService do
  describe "run" do
    subject(:run_service) { described_class.run(registration: decorated_registration) }

    let(:registration) { create(:registration, :expires_soon, :simple_address) }
    let(:decorated_registration) do
      NotifyRenewalPresenter.new(registration)
    end
    let(:template_id) { "c23c1300-6d49-4310-bda6-99174ca0cd23" }

    let(:client) { instance_double(Notifications::Client) }
    let(:notifications_client_response_notification) { instance_double(Notifications::Client::ResponseNotification) }

    before do
      allow(Notifications::Client).to receive(:new).and_return(client)
      allow(client).to receive(:send_sms).and_return(notifications_client_response_notification)
      allow(notifications_client_response_notification).to receive(:instance_of?)
        .with(Notifications::Client::ResponseNotification)
        .and_return(true)
    end

    it "sends an sms" do
      run_service
      expect(client).to have_received(:send_sms).with(
        hash_including(
          template_id: template_id,
          phone_number: decorated_registration.phone_number,
          personalisation: hash_including(
            expiry_date: decorated_registration.expiry_date,
            reg_identifier: decorated_registration.reg_identifier,
            renewal_cost: decorated_registration.renewal_cost
          )
        )
      )
    end

    it_behaves_like "can create a communication record", "sms"
  end
end
