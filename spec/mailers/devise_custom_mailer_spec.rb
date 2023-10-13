# frozen_string_literal: true

require "rails_helper"
RSpec.describe DeviseCustomMailer do
  subject(:mailer) { described_class.new }

  let(:user) { create(:user, email: "test@example.com") }
  let(:token) { "example_token" }
  let(:opts) { {} }

  describe "#invitation_instructions" do
    let(:mailer_method) { :invitation_instructions }

    before do
      allow(Notify::DeviseSender).to receive(:run)
      mailer.public_send(mailer_method, user, token, opts)
    end

    it "calls the DeviseSender with correct arguments" do
      expect(Notify::DeviseSender).to have_received(:run).with(
        template: :invitation_instructions,
        record: user,
        opts: opts.merge(token: token)
      )
    end
  end

  describe "#reset_password_instructions" do
    let(:mailer_method) { :reset_password_instructions }

    before do
      allow(Notify::DeviseSender).to receive(:run)
      mailer.public_send(mailer_method, user, token, opts)
    end

    it "calls the DeviseSender with correct arguments" do
      expect(Notify::DeviseSender).to have_received(:run).with(
        template: :reset_password_instructions,
        record: user,
        opts: opts.merge(token: token)
      )
    end
  end

  describe "#unlock_instructions" do
    let(:mailer_method) { :unlock_instructions }

    before do
      allow(Notify::DeviseSender).to receive(:run)
      mailer.public_send(mailer_method, user, token, opts)
    end

    it "calls the DeviseSender with correct arguments" do
      expect(Notify::DeviseSender).to have_received(:run).with(
        template: :unlock_instructions,
        record: user,
        opts: opts.merge(token: token)
      )
    end
  end
end
