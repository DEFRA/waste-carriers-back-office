# frozen_string_literal: true

require "rails_helper"

RSpec.describe Notify::DigitalRenewalSmsService do
  describe "run" do
    let(:decorated_registration) do
      NotifyRenewalPresenter.new(create(:registration, :expires_soon, :simple_address))
    end

    let(:client) { instance_double(Notifications::Client) }

    before do
      allow(Notifications::Client).to receive(:new).and_return(client)
      allow(client).to receive(:send_sms)
    end

    it "sends an sms" do
      described_class.run(registration: decorated_registration)
      expect(client).to have_received(:send_sms).with(
        hash_including(
          template_id: Notify::DigitalRenewalSmsService::TEMPLATE_ID,
          phone_number: decorated_registration.phone_number,
          personalisation: hash_including(
            expiry_date: decorated_registration.expiry_date,
            reg_identifier: decorated_registration.reg_identifier,
            renewal_cost: decorated_registration.renewal_cost
          )
        )
      )
    end
  end
end
