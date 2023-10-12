# frozen_string_literal: true

require "rails_helper"

RSpec.describe DeviseCustomMailer do
  let(:user) { create(:user, email: "test@example.com") }
  let(:token) { "example_token" }
  let(:opts) { {} }

  describe '#invitation_instructions' do
    it 'calls the DeviseSender with correct arguments' do
      expect(Notify::DeviseSender).to receive(:run).with(
        template: :invitation_instructions,
        record: user,
        opts: opts.merge(token: token)
      )
      subject.invitation_instructions(user, token, opts)
    end
  end

  describe '#reset_password_instructions' do
    it 'calls the DeviseSender with correct arguments' do
      expect(Notify::DeviseSender).to receive(:run).with(
        template: :reset_password_instructions,
        record: user,
        opts: opts.merge(token: token)
      )
      subject.reset_password_instructions(user, token, opts)
    end
  end

  describe '#unlock_instructions' do
    it 'calls the DeviseSender with correct arguments' do
      expect(Notify::DeviseSender).to receive(:run).with(
        template: :unlock_instructions,
        record: user,
        opts: opts.merge(token: token)
      )
      subject.unlock_instructions(user, token, opts)
    end
  end
end
