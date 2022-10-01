# frozen_string_literal: true

require "rails_helper"

RSpec.describe RegistrationTransfersHelper, type: :helper do
  let(:external_user) { create(:external_user) }
  let(:email) { external_user[:email] }
  let(:registration) { build(:registration) }

  describe "#newly_invited_account?" do
    subject { helper.newly_invited_account?(email) }

    context "when there is an invitation_created_at" do
      before do
        external_user.update(invitation_created_at: Time.current)
      end

      context "when there is no invitation_accepted_at" do
        it "returns true" do
          expect(subject).to be(true)
        end
      end

      context "when there is an invitation_accepted_at" do
        before do
          external_user.update(invitation_accepted_at: Time.current)
        end

        it "returns false" do
          expect(subject).to be(false)
        end
      end
    end

    context "when there is no invitation_created_at" do
      it "returns false" do
        expect(subject).to be(false)
      end
    end
  end
end
