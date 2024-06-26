# frozen_string_literal: true

require "cancan/matchers"
require "rails_helper"

RSpec.describe User do
  describe "#active?" do
    context "when 'active' is true" do
      let(:user) { described_class.new(active: true) }

      it "returns true" do
        expect(user.active?).to be(true)
      end
    end

    context "when 'active' is false" do
      let(:user) { described_class.new(active: false) }

      it "returns false" do
        expect(user.active?).to be(false)
      end
    end

    context "when 'active' is nil" do
      let(:user) { described_class.new(active: nil) }

      it "returns true" do
        expect(user.active?).to be(true)
      end
    end
  end

  describe "#deactivated?" do
    let(:user) { described_class.new }

    context "when 'active?' returns true" do
      before { allow(user).to receive(:active?).and_return(true) }

      it "returns false" do
        expect(user.deactivated?).to be(false)
      end
    end

    context "when 'active?' returns false" do
      before { allow(user).to receive(:active?).and_return(false) }

      it "returns true" do
        expect(user.deactivated?).to be(true)
      end
    end
  end

  describe "#activate!" do
    let(:user) { build(:user, :inactive) }

    it "makes the user active" do
      user.activate!
      expect(user.active).to be(true)
    end
  end

  describe "#deactivate!" do
    let(:user) { build(:user) }

    it "makes the user inactive" do
      user.deactivate!
      expect(user.active).to be(false)
    end
  end

  it_behaves_like "a user", :user

  describe "#in_agency_group?" do
    context "when the role is agency" do
      let(:user) { build(:user, role: :agency) }

      it "is true" do
        expect(user.in_agency_group?).to be(true)
      end
    end

    context "when the role is agency_with_refund" do
      let(:user) { build(:user, role: :agency_with_refund) }

      it "is true" do
        expect(user.in_agency_group?).to be(true)
      end
    end

    context "when the role is agency_super" do
      let(:user) { build(:user, role: :agency_super) }

      it "is true" do
        expect(user.in_agency_group?).to be(true)
      end
    end

    context "when the role is cbd_user" do
      let(:user) { build(:user, role: :cbd_user) }

      it "is true" do
        expect(user.in_agency_group?).to be(true)
      end
    end

    context "when the role is finance" do
      let(:user) { build(:user, role: :finance) }

      it "is false" do
        expect(user.in_agency_group?).to be(false)
      end
    end

    context "when the role is finance_admin" do
      let(:user) { build(:user, role: :finance_admin) }

      it "is false" do
        expect(user.in_agency_group?).to be(false)
      end
    end

    context "when the role is finance_super" do
      let(:user) { build(:user, role: :finance_super) }

      it "is false" do
        expect(user.in_agency_group?).to be(false)
      end
    end

    context "when the role is nil" do
      let(:user) { build(:user, role: nil) }

      it "is false" do
        expect(user.in_agency_group?).to be(false)
      end
    end
  end

  describe "#in_finance_group?" do
    context "when the role is finance" do
      let(:user) { build(:user, role: :finance) }

      it "is true" do
        expect(user.in_finance_group?).to be(true)
      end
    end

    context "when the role is finance_admin" do
      let(:user) { build(:user, role: :finance_admin) }

      it "is true" do
        expect(user.in_finance_group?).to be(true)
      end
    end

    context "when the role is finance_super" do
      let(:user) { build(:user, role: :finance_super) }

      it "is true" do
        expect(user.in_finance_group?).to be(true)
      end
    end

    context "when the role is agency" do
      let(:user) { build(:user, role: :agency) }

      it "is false" do
        expect(user.in_finance_group?).to be(false)
      end
    end

    context "when the role is agency_with_refund" do
      let(:user) { build(:user, role: :agency_with_refund) }

      it "is false" do
        expect(user.in_finance_group?).to be(false)
      end
    end

    context "when the role is agency_super" do
      let(:user) { build(:user, role: :agency_super) }

      it "is false" do
        expect(user.in_finance_group?).to be(false)
      end
    end

    context "when the role is nil" do
      let(:user) { build(:user, role: nil) }

      it "is false" do
        expect(user.in_finance_group?).to be(false)
      end
    end
  end

  describe "change_role" do
    let(:user) { create(:user, role: :agency) }

    it "updates the user's role" do
      new_role = "agency_with_refund"
      user.change_role(new_role)

      expect(user.reload.role).to eq(new_role)
    end

    context "when the new role is invalid" do
      it "does not update the user's role" do
        new_role = "foo"
        user.change_role(new_role)

        expect(user.reload.role).not_to eq(new_role)
      end
    end
  end

  describe "role" do
    context "when the role is agency" do
      let(:user) { build(:user, role: :agency) }

      it "is valid" do
        expect(user).to be_valid
      end
    end

    context "when the role is agency_with_refund" do
      let(:user) { build(:user, role: :agency_with_refund) }

      it "is valid" do
        expect(user).to be_valid
      end
    end

    context "when the role is finance" do
      let(:user) { build(:user, role: :finance) }

      it "is valid" do
        expect(user).to be_valid
      end
    end

    context "when the role is finance_admin" do
      let(:user) { build(:user, role: :finance_admin) }

      it "is valid" do
        expect(user).to be_valid
      end
    end

    context "when the role is agency_super" do
      let(:user) { build(:user, role: :agency_super) }

      it "is valid" do
        expect(user).to be_valid
      end
    end

    context "when the role is finance_super" do
      let(:user) { build(:user, role: :finance_super) }

      it "is valid" do
        expect(user).to be_valid
      end
    end

    context "when the role is nil" do
      let(:user) { build(:user, role: nil) }

      it "is not valid" do
        expect(user).not_to be_valid
      end
    end

    context "when the role is not allowed" do
      let(:user) { build(:user, role: "foo") }

      it "is not valid" do
        expect(user).not_to be_valid
      end
    end
  end
end
