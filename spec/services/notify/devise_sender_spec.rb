# frozen_string_literal: true

require "rails_helper"

module Notify
  RSpec.describe DeviseSender do
    let(:user_with_email) { create(:user, email: "test@example.com", invitation_sent_at: Time.zone.now) }
    let(:token) { "example_token" }

    let(:notifications_client) { instance_double(Notifications::Client) }

    before do
      allow(Notifications::Client).to receive(:new).and_return(notifications_client)
      allow(notifications_client).to receive(:send_email)
    end

    describe ".run" do
      it "creates a new instance and calls the instance run method" do
        instance = described_class.new
        allow(described_class).to receive(:new).and_return(instance)
        allow(instance).to receive(:run)

        described_class.run(template: :reset_password_instructions, record: user_with_email, opts: { token: token })

        expect(instance).to have_received(:run).with(
          template: :reset_password_instructions,
          record: user_with_email,
          opts: { token: token }
        )
      end
    end

    describe "#run" do
      context "with :reset_password_instructions template" do
        it "uses ResetPasswordInstructionsEmailService" do
          allow(ResetPasswordInstructionsEmailService).to receive(:new).and_call_original
          described_class.new.run(template: :reset_password_instructions, record: user_with_email, opts: { token: token })

          expect(ResetPasswordInstructionsEmailService).to have_received(:new)
        end
      end

      context "with :unlock_instructions template" do
        it "uses UnlockInstructionsEmailService" do
          allow(UnlockInstructionsEmailService).to receive(:new).and_call_original
          described_class.new.run(template: :unlock_instructions, record: user_with_email, opts: { token: token })

          expect(UnlockInstructionsEmailService).to have_received(:new)
        end
      end

      context "with :invitation_instructions template" do
        it "uses InvitationInstructionsEmailService" do
          allow(InvitationInstructionsEmailService).to receive(:new).and_call_original
          described_class.new.run(template: :invitation_instructions, record: user_with_email, opts: { token: token })

          expect(InvitationInstructionsEmailService).to have_received(:new)
        end
      end

      context "with unknown template" do
        it "raises an error" do
          expect do
            described_class.new.run(template: :unknown_template, record: user_with_email, opts: { token: token })
          end.to raise_error(ArgumentError, "Unknown email template: unknown_template")
        end
      end
    end
  end
end
