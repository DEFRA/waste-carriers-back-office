# frozen_string_literal: true

require "cancan/matchers"
require "rails_helper"

RSpec.describe User, type: :model do
  describe "#password" do
    context "when the user's password meets the requirements" do
      let(:user) { build(:user, password: "Secret123") }

      it "should be valid" do
        expect(user).to be_valid
      end
    end

    context "when the user's password is blank" do
      let(:user) { build(:user, password: "") }

      it "should not be valid" do
        expect(user).to_not be_valid
      end
    end

    context "when the user's password has no lowercase letters" do
      let(:user) { build(:user, password: "SECRET123") }

      it "should not be valid" do
        expect(user).to_not be_valid
      end
    end

    context "when the user's password has no uppercase letters" do
      let(:user) { build(:user, password: "secret123") }

      it "should not be valid" do
        expect(user).to_not be_valid
      end
    end

    context "when the user's password has no numbers" do
      let(:user) { build(:user, password: "SuperSecret") }

      it "should not be valid" do
        expect(user).to_not be_valid
      end
    end

    context "when the user's password is too short" do
      let(:user) { build(:user, password: "Sec123") }

      it "should not be valid" do
        expect(user).to_not be_valid
      end
    end
  end

  describe "#in_agency_group?" do
    context "when the role is agency" do
      let(:user) { build(:user, :agency) }

      it "is true" do
        expect(user.in_agency_group?).to eq(true)
      end
    end

    context "when the role is agency_with_refund" do
      let(:user) { build(:user, :agency_with_refund) }

      it "is true" do
        expect(user.in_agency_group?).to eq(true)
      end
    end

    context "when the role is agency_super" do
      let(:user) { build(:user, :agency_super) }

      it "is true" do
        expect(user.in_agency_group?).to eq(true)
      end
    end

    context "when the role is finance" do
      let(:user) { build(:user, :finance) }

      it "is false" do
        expect(user.in_agency_group?).to eq(false)
      end
    end

    context "when the role is finance_admin" do
      let(:user) { build(:user, :finance_admin) }

      it "is false" do
        expect(user.in_agency_group?).to eq(false)
      end
    end

    context "when the role is finance_super" do
      let(:user) { build(:user, :finance_super) }

      it "is false" do
        expect(user.in_agency_group?).to eq(false)
      end
    end

    context "when the role is nil" do
      let(:user) { build(:user, role: nil) }

      it "is false" do
        expect(user.in_agency_group?).to eq(false)
      end
    end
  end

  describe "#in_finance_group?" do
    context "when the role is finance" do
      let(:user) { build(:user, :finance) }

      it "is true" do
        expect(user.in_finance_group?).to eq(true)
      end
    end

    context "when the role is finance_admin" do
      let(:user) { build(:user, :finance_admin) }

      it "is true" do
        expect(user.in_finance_group?).to eq(true)
      end
    end

    context "when the role is finance_super" do
      let(:user) { build(:user, :finance_super) }

      it "is true" do
        expect(user.in_finance_group?).to eq(true)
      end
    end

    context "when the role is agency" do
      let(:user) { build(:user, :agency) }

      it "is false" do
        expect(user.in_finance_group?).to eq(false)
      end
    end

    context "when the role is agency_with_refund" do
      let(:user) { build(:user, :agency_with_refund) }

      it "is false" do
        expect(user.in_finance_group?).to eq(false)
      end
    end

    context "when the role is agency_super" do
      let(:user) { build(:user, :agency_super) }

      it "is false" do
        expect(user.in_finance_group?).to eq(false)
      end
    end

    context "when the role is nil" do
      let(:user) { build(:user, role: nil) }

      it "is false" do
        expect(user.in_finance_group?).to eq(false)
      end
    end
  end

  describe "role" do
    context "when the role is agency" do
      let(:user) { build(:user, :agency) }

      it "is valid" do
        expect(user).to be_valid
      end
    end

    context "when the role is agency_with_refund" do
      let(:user) { build(:user, :agency_with_refund) }

      it "is valid" do
        expect(user).to be_valid
      end
    end

    context "when the role is finance" do
      let(:user) { build(:user, :finance) }

      it "is valid" do
        expect(user).to be_valid
      end
    end

    context "when the role is finance_admin" do
      let(:user) { build(:user, :finance_admin) }

      it "is valid" do
        expect(user).to be_valid
      end
    end

    context "when the role is agency_super" do
      let(:user) { build(:user, :agency_super) }

      it "is valid" do
        expect(user).to be_valid
      end
    end

    context "when the role is finance_super" do
      let(:user) { build(:user, :finance_super) }

      it "is valid" do
        expect(user).to be_valid
      end
    end

    context "when the role is nil" do
      let(:user) { build(:user, role: nil) }

      it "is not valid" do
        expect(user).to_not be_valid
      end
    end

    context "when the role is not allowed" do
      let(:user) { build(:user, role: "foo") }

      it "is not valid" do
        expect(user).to_not be_valid
      end
    end
  end
end
