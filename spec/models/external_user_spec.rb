# frozen_string_literal: true

require "cancan/matchers"
require "rails_helper"

RSpec.describe ExternalUser, type: :model do
  describe "#password" do
    context "when the external_user's password meets the requirements" do
      let(:external_user) { build(:external_user, password: "Secret123") }

      it "should be valid" do
        expect(external_user).to be_valid
      end
    end

    context "when the external_user's password is blank" do
      let(:external_user) { build(:external_user, password: "") }

      it "should not be valid" do
        expect(external_user).to_not be_valid
      end
    end

    context "when the external_user's password has no lowercase letters" do
      let(:external_user) { build(:external_user, password: "SECRET123") }

      it "should not be valid" do
        expect(external_user).to_not be_valid
      end
    end

    context "when the external_user's password has no uppercase letters" do
      let(:external_user) { build(:external_user, password: "secret123") }

      it "should not be valid" do
        expect(external_user).to_not be_valid
      end
    end

    context "when the external_user's password has no numbers" do
      let(:external_user) { build(:external_user, password: "SuperSecret") }

      it "should not be valid" do
        expect(external_user).to_not be_valid
      end
    end

    context "when the external_user's password is too short" do
      let(:external_user) { build(:external_user, password: "Sec123") }

      it "should not be valid" do
        expect(external_user).to_not be_valid
      end
    end
  end
end
