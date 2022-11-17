# frozen_string_literal: true

require "rails_helper"

RSpec.describe Reports::UserPresenter do
  subject { described_class.new(user) }

  describe "#email" do
    let(:user) { build(:user) }

    it "returns the email address" do
      expect(subject.email).to eq(user.email)
    end
  end

  describe "#status" do
    context "with an active user" do
      let(:user) { build(:user, active: true) }

      it "returns 'Active'" do
        expect(subject.status).to eq("Active")
      end
    end

    context "with an invited user" do
      let(:user) do
        build(:user, active: false, invitation_sent_at: Time.at(0).utc)
      end

      it "returns 'Invitation Sent'" do
        expect(subject.status).to eq("Invitation Sent")
      end
    end

    context "with a deactivated user" do
      let(:user) { build(:user, active: false) }

      it "returns 'Deactivated'" do
        expect(subject.status).to eq("Deactivated")
      end
    end
  end

  describe "#current_sign_in_at" do
    context "with a previously signed in user" do
      let(:user) do
        build(:user, active: false, current_sign_in_at: Time.at(0).utc)
      end

      it "returns the date/time in the correct format" do
        expect(subject.current_sign_in_at).to eq("01/01/1970 00:00")
      end
    end

    context "with a user that never signed in" do
      let(:user) do
        build(:user, active: false, current_sign_in_at: nil)
      end

      it "returns the date/time in the correct format" do
        expect(subject.current_sign_in_at).to be_nil
      end
    end
  end

  describe "#invitation_accepted_at" do
    context "with an invited user" do
      let(:user) do
        build(:user, active: false, invitation_accepted_at: Time.at(0).utc)
      end

      it "returns the date/time in the correct format" do
        expect(subject.invitation_accepted_at).to eq("01/01/1970 00:00")
      end
    end

    context "with an uninvited user" do
      let(:user) do
        build(:user, active: false, invitation_accepted_at: nil)
      end

      it "returns the date/time in the correct format" do
        expect(subject.invitation_accepted_at).to be_nil
      end
    end
  end
end
