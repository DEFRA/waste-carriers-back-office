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

  describe "abilities" do
    subject(:ability) { Ability.new(user) }
    let(:user) { build(:user) }
    let(:transient_registration) { build(:transient_registration) }
    let(:other_user) { build(:user) }

    context "when the user is an agency user" do
      let(:user) { build(:user, :agency) }

      it "should be able to update a transient registration" do
        should be_able_to(:update, transient_registration)
      end

      it "should be able to record a cash payment" do
        should be_able_to(:record_cash_payment, transient_registration)
      end

      it "should be able to record a cheque payment" do
        should be_able_to(:record_cheque_payment, transient_registration)
      end

      it "should be able to record a postal order payment" do
        should be_able_to(:record_postal_order_payment, transient_registration)
      end

      it "should not be able to record a transfer payment" do
        should_not be_able_to(:record_transfer_payment, transient_registration)
      end

      it "should not be able to record a worldpay payment" do
        should_not be_able_to(:record_worldpay_missed_payment, transient_registration)
      end

      it "should be able to review convictions" do
        should be_able_to(:review_convictions, transient_registration)
      end

      it "should not be able to create an agency user" do
        should_not be_able_to(:create_agency_user, user)
      end

      it "should not be able to create an agency_with_refund user" do
        should_not be_able_to(:create_agency_with_refund_user, user)
      end

      it "should not be able to create a finance user" do
        should_not be_able_to(:create_finance_user, user)
      end

      it "should not be able to create a finance admin user" do
        should_not be_able_to(:create_finance_admin_user, user)
      end
    end

    context "when the user is an agency with refund user" do
      let(:user) { build(:user, :agency_with_refund) }

      it "should be able to update a transient registration" do
        should be_able_to(:update, transient_registration)
      end

      it "should be able to record a cash payment" do
        should be_able_to(:record_cash_payment, transient_registration)
      end

      it "should be able to record a cheque payment" do
        should be_able_to(:record_cheque_payment, transient_registration)
      end

      it "should be able to record a postal order payment" do
        should be_able_to(:record_postal_order_payment, transient_registration)
      end

      it "should not be able to record a transfer payment" do
        should_not be_able_to(:record_transfer_payment, transient_registration)
      end

      it "should not be able to record a worldpay payment" do
        should_not be_able_to(:record_worldpay_missed_payment, transient_registration)
      end

      it "should be able to review convictions" do
        should be_able_to(:review_convictions, transient_registration)
      end

      it "should not be able to create an agency user" do
        should_not be_able_to(:create_agency_user, user)
      end

      it "should not be able to create an agency_with_refund user" do
        should_not be_able_to(:create_agency_with_refund_user, user)
      end

      it "should not be able to create a finance user" do
        should_not be_able_to(:create_finance_user, user)
      end

      it "should not be able to create a finance admin user" do
        should_not be_able_to(:create_finance_admin_user, user)
      end
    end

    context "when the user is a finance user" do
      let(:user) { build(:user, :finance) }

      it "should not be able to update a transient registration" do
        should_not be_able_to(:update, transient_registration)
      end

      it "should not be able to record a cash payment" do
        should_not be_able_to(:record_cash_payment, transient_registration)
      end

      it "should not be able to record a cheque payment" do
        should_not be_able_to(:record_cheque_payment, transient_registration)
      end

      it "should not be able to record a postal order payment" do
        should_not be_able_to(:record_postal_order_payment, transient_registration)
      end

      it "should be able to record a transfer payment" do
        should be_able_to(:record_transfer_payment, transient_registration)
      end

      it "should not be able to record a worldpay payment" do
        should_not be_able_to(:record_worldpay_missed_payment, transient_registration)
      end

      it "should not be able to review convictions" do
        should_not be_able_to(:review_convictions, transient_registration)
      end

      it "should not be able to create an agency user" do
        should_not be_able_to(:create_agency_user, user)
      end

      it "should not be able to create an agency_with_refund user" do
        should_not be_able_to(:create_agency_with_refund_user, user)
      end

      it "should not be able to create a finance user" do
        should_not be_able_to(:create_finance_user, user)
      end

      it "should not be able to create a finance admin user" do
        should_not be_able_to(:create_finance_admin_user, user)
      end
    end

    context "when the user is a finance admin user" do
      let(:user) { build(:user, :finance_admin) }

      it "should not be able to update a transient registration" do
        should_not be_able_to(:update, transient_registration)
      end

      it "should not be able to record a cash payment" do
        should_not be_able_to(:record_cash_payment, transient_registration)
      end

      it "should not be able to record a cheque payment" do
        should_not be_able_to(:record_cheque_payment, transient_registration)
      end

      it "should not be able to record a postal order payment" do
        should_not be_able_to(:record_postal_order_payment, transient_registration)
      end

      it "should not be able to record a transfer payment" do
        should_not be_able_to(:record_transfer_payment, transient_registration)
      end

      it "should be able to record a worldpay payment" do
        should be_able_to(:record_worldpay_missed_payment, transient_registration)
      end

      it "should not be able to review convictions" do
        should_not be_able_to(:review_convictions, transient_registration)
      end

      it "should not be able to create an agency user" do
        should_not be_able_to(:create_agency_user, user)
      end

      it "should not be able to create an agency_with_refund user" do
        should_not be_able_to(:create_agency_with_refund_user, user)
      end

      it "should not be able to create a finance user" do
        should_not be_able_to(:create_finance_user, user)
      end

      it "should not be able to create a finance admin user" do
        should_not be_able_to(:create_finance_admin_user, user)
      end
    end

    context "when the user is an agency super user" do
      let(:user) { build(:user, :agency_super) }

      it "should be able to update a transient registration" do
        should be_able_to(:update, transient_registration)
      end

      it "should be able to record a cash payment" do
        should be_able_to(:record_cash_payment, transient_registration)
      end

      it "should be able to record a cheque payment" do
        should be_able_to(:record_cheque_payment, transient_registration)
      end

      it "should be able to record a postal order payment" do
        should be_able_to(:record_postal_order_payment, transient_registration)
      end

      it "should not be able to record a transfer payment" do
        should_not be_able_to(:record_transfer_payment, transient_registration)
      end

      it "should not be able to record a worldpay payment" do
        should_not be_able_to(:record_worldpay_missed_payment, transient_registration)
      end

      it "should be able to review convictions" do
        should be_able_to(:review_convictions, transient_registration)
      end

      it "should be able to create an agency user" do
        should be_able_to(:create_agency_user, user)
      end

      it "should not be able to create an agency_with_refund user" do
        should_not be_able_to(:create_agency_with_refund_user, user)
      end

      it "should not be able to create a finance user" do
        should_not be_able_to(:create_finance_user, user)
      end

      it "should not be able to create a finance admin user" do
        should_not be_able_to(:create_finance_admin_user, user)
      end
    end

    context "when the user is a finance super user" do
      let(:user) { build(:user, :finance_super) }

      it "should not be able to update a transient registration" do
        should_not be_able_to(:update, transient_registration)
      end

      it "should not be able to record a cash payment" do
        should_not be_able_to(:record_cash_payment, transient_registration)
      end

      it "should not be able to record a cheque payment" do
        should_not be_able_to(:record_cheque_payment, transient_registration)
      end

      it "should not be able to record a postal order payment" do
        should_not be_able_to(:record_postal_order_payment, transient_registration)
      end

      it "should not be able to record a transfer payment" do
        should_not be_able_to(:record_transfer_payment, transient_registration)
      end

      it "should not be able to record a worldpay payment" do
        should_not be_able_to(:record_worldpay_missed_payment, transient_registration)
      end

      it "should not be able to review convictions" do
        should_not be_able_to(:review_convictions, transient_registration)
      end

      it "should be able to create an agency user" do
        should be_able_to(:create_agency_user, user)
      end

      it "should be able to create an agency_with_refund user" do
        should be_able_to(:create_agency_with_refund_user, user)
      end

      it "should be able to create a finance user" do
        should be_able_to(:create_finance_user, user)
      end

      it "should be able to create a finance admin user" do
        should be_able_to(:create_finance_admin_user, user)
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
