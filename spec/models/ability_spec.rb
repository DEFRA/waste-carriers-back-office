# frozen_string_literal: true

require "cancan/matchers"
require "rails_helper"

RSpec.describe Ability do

  let(:all_roles) do
    %w[
      agency_super
      agency_with_refund
      agency
      cbd_user
      data_agent
      developer
      finance_super
      finance_admin
      finance
    ]
  end
  let(:not_permitted_roles) { all_roles - permitted_roles }
  let(:agency_plus_roles) { %w[agency_super agency_with_refund agency cbd_user developer] }

  shared_examples "allows only the permitted roles" do |deactivated, action, entity|

    it "allows the permitted roles for #{action}" do
      permitted_roles.each do |role|
        user = instance_double(User, role: role, deactivated?: deactivated)
        expect(described_class.new(user)).to be_able_to(action, entity)
      rescue RSpec::Expectations::ExpectationNotMetError, RSpec::Expectations::MultipleExpectationsNotMetError => e
        puts "*** expectation failed for role #{role}"
        raise e
      end
    end

    it "does not allow the non-permitted roles for #{action}}" do
      not_permitted_roles.each do |role|
        user = instance_double(User, role: role, deactivated?: deactivated)
        expect(described_class.new(user)).not_to be_able_to(action, entity)
      rescue RSpec::Expectations::ExpectationNotMetError, RSpec::Expectations::MultipleExpectationsNotMetError => e
        puts "*** expectation failed for role #{role}"
        raise e
      end
    end
  end

  # active / deactivated

  context "when the user is active" do
    let(:permitted_roles) { all_roles }

    it_behaves_like "allows only the permitted roles", false, :use_back_office, :all
  end

  context "when the user is deactivated" do
    let(:permitted_roles) { [] }

    it_behaves_like "allows only the permitted roles", true, :use_back_office, :all
  end

  # registration actions

  context "when the action is create a registration" do
    let(:permitted_roles) { agency_plus_roles }

    it_behaves_like "allows only the permitted roles", false, :create, WasteCarriersEngine::Registration
  end

  context "when the action is cease a registration" do
    let(:permitted_roles) do
      %w[
        agency_super
        agency_with_refund
      ]
    end

    it_behaves_like "allows only the permitted roles", false, :cease, WasteCarriersEngine::Registration
  end

  context "when the action is revoke a registration" do
    let(:permitted_roles) do
      %w[
        agency_super
        agency_with_refund
      ]
    end

    it_behaves_like "allows only the permitted roles", false, :revoke, WasteCarriersEngine::Registration
  end

  context "when the action is restore a registration" do
    let(:permitted_roles) do
      %w[
        agency_super
        agency_with_refund
      ]
    end

    it_behaves_like "allows only the permitted roles", false, :restore, WasteCarriersEngine::Registration
  end

  context "when the action is edit a registration" do
    let(:permitted_roles) { agency_plus_roles }

    it_behaves_like "allows only the permitted roles", false, :edit, WasteCarriersEngine::Registration
  end

  context "when the action is cancel a resource" do
    let(:permitted_roles) do
      %w[
        agency_super
        agency_with_refund
      ]
    end

    it_behaves_like "allows only the permitted roles", false, :cancel, WasteCarriersEngine::Registration
  end

  context "when the action is view revoked reasons" do
    let(:permitted_roles) do
      %w[
        agency_super
        agency_with_refund
        data_agent
      ]
    end

    it_behaves_like "allows only the permitted roles", false, :view_revoked_reasons, WasteCarriersEngine::RenewingRegistration
  end

  context "when the action is view the certificate" do
    let(:permitted_roles) { all_roles }

    it_behaves_like "allows only the permitted roles", false, :view_certificate, WasteCarriersEngine::Registration
  end

  context "when the action is update a transient registration" do
    let(:permitted_roles) { agency_plus_roles }

    it_behaves_like "allows only the permitted roles", false, :update, WasteCarriersEngine::RenewingRegistration
  end

  context "when the action is revert to payment summary" do
    let(:permitted_roles) { agency_plus_roles }

    it_behaves_like "allows only the permitted roles", false, :revert_to_payment_summary, WasteCarriersEngine::RenewingRegistration
  end

  context "when the action is resend a confirmation email" do
    let(:permitted_roles) { agency_plus_roles }

    it_behaves_like "allows only the permitted roles", false, :resend_confirmation_email, WasteCarriersEngine::Registration
  end

  context "when the action is refresh the company name" do
    let(:permitted_roles) { agency_plus_roles }

    it_behaves_like "allows only the permitted roles", false, :refresh_company_name, WasteCarriersEngine::Registration
  end

  # payments and write-offs

  context "when the action is record a cash payment" do
    let(:permitted_roles) do
      %w[
        agency_super
        agency_with_refund
      ]
    end

    it_behaves_like "allows only the permitted roles", false, :record_cash_payment, WasteCarriersEngine::RenewingRegistration
  end

  context "when the action is record a bank transfer payment" do
    let(:permitted_roles) { %w[finance] }

    it_behaves_like "allows only the permitted roles", false, :record_bank_transfer_payment, WasteCarriersEngine::RenewingRegistration
  end

  context "when the action is record a cheque payment" do
    let(:permitted_roles) do
      %w[
        agency_super
        agency_with_refund
      ]
    end

    it_behaves_like "allows only the permitted roles", false, :record_cheque_payment, WasteCarriersEngine::RenewingRegistration
  end

  context "when the action is record a postal order payment" do
    let(:permitted_roles) do
      %w[
        agency_super
        agency_with_refund
      ]
    end

    it_behaves_like "allows only the permitted roles", false, :record_postal_order_payment, WasteCarriersEngine::RenewingRegistration
  end

  context "when the action is view payments" do
    let(:permitted_roles) do
      %w[
        agency_super
        agency_with_refund
        finance_super
        finance_admin
        finance
      ]
    end

    it_behaves_like "allows only the permitted roles", false, :view_payments, WasteCarriersEngine::RenewingRegistration
  end

  context "when the action is refund a payment" do
    let(:permitted_roles) do
      %w[
        agency_super
        agency_with_refund
      ]
    end

    it_behaves_like "allows only the permitted roles", false, :refund, WasteCarriersEngine::Registration
  end

  context "when the action is reverse a payment" do
    let(:permitted_roles) do
      %w[
        agency_super
        agency_with_refund
      ]
    end

    context "when the payment is a cash payment" do
      it_behaves_like "allows only the permitted roles", false, :reverse,
                      WasteCarriersEngine::Payment.new(payment_type: WasteCarriersEngine::Payment::CASH)
    end

    context "when the payment is a cheque payment" do
      it_behaves_like "allows only the permitted roles", false, :reverse,
                      WasteCarriersEngine::Payment.new(payment_type: WasteCarriersEngine::Payment::CHEQUE)
    end

    context "when the payment is a postal order" do
      it_behaves_like "allows only the permitted roles", false, :reverse,
                      WasteCarriersEngine::Payment.new(payment_type: WasteCarriersEngine::Payment::POSTALORDER)
    end

    context "when the payment is a govpay payment" do
      let(:permitted_roles) do
        %w[
          finance_super
          finance_admin
        ]
      end

      it_behaves_like "allows only the permitted roles", false, :reverse,
                      WasteCarriersEngine::Payment.new(payment_type: WasteCarriersEngine::Payment::GOVPAY)
    end

    context "when the payment is a bank transfer payment" do
      let(:permitted_roles) do
        %w[
          finance
        ]
      end

      it_behaves_like "allows only the permitted roles", false, :reverse,
                      WasteCarriersEngine::Payment.new(payment_type: WasteCarriersEngine::Payment::BANKTRANSFER)
    end

    context "when the payment is another type" do
      let(:permitted_roles) { %w[] }

      it_behaves_like "allows only the permitted roles", false, :reverse,
                      WasteCarriersEngine::Payment.new(payment_type: WasteCarriersEngine::Payment::MISSED_CARD)
    end
  end

  context "when the action is write off small" do
    let(:permitted_roles) do
      %w[
        agency_super
        agency_with_refund
      ]
    end

    context "when the zero-difference balance is less than the write-off cap for agency users" do
      it_behaves_like "allows only the permitted roles", false, :write_off_small,
                      WasteCarriersEngine::FinanceDetails.new(balance:
                        WasteCarriersBackOffice::Application.config.write_off_agency_user_cap.to_i - 1)
    end

    context "when the zero-difference balance is equal to the write-off cap for agency users" do
      it_behaves_like "allows only the permitted roles", false, :write_off_small,
                      WasteCarriersEngine::FinanceDetails.new(balance:
                         WasteCarriersBackOffice::Application.config.write_off_agency_user_cap.to_i)
    end

    context "when the zero-difference balance is greater than the write-off cap for agency users" do
      let(:permitted_roles) { %w[] }

      it_behaves_like "allows only the permitted roles", false, :write_off_small,
                      WasteCarriersEngine::FinanceDetails.new(balance:
                        WasteCarriersBackOffice::Application.config.write_off_agency_user_cap.to_i + 1)
    end
  end

  context "when the action is write off large" do
    let(:permitted_roles) do
      %w[
        finance_super
        finance_admin
      ]
    end

    it_behaves_like "allows only the permitted roles", false, :write_off_large, WasteCarriersEngine::FinanceDetails
  end

  context "when the action is charge adjust a resource" do
    let(:permitted_roles) do
      %w[
        finance_admin
        finance_super
      ]
    end

    it_behaves_like "allows only the permitted roles", false, :charge_adjust, WasteCarriersEngine::RenewingRegistration
  end

  # managing users

  context "when the action is manage back office users" do
    let(:permitted_roles) do
      %w[
        agency_super
        cbd_user
        finance_super
        agency_with_refund
      ]
    end

    it_behaves_like "allows only the permitted roles", false, :manage_back_office_users, User
  end

  context "when the action is modify agency users" do
    let(:permitted_roles) { %w[agency_super] }

    it_behaves_like "allows only the permitted roles", false, :modify_user, User.new(role: :agency)
  end

  context "when the action is modify data_agent users" do
    let(:permitted_roles) do
      %w[
        agency_super
        cbd_user
      ]
    end

    it_behaves_like "allows only the permitted roles", false, :modify_user, User.new(role: :data_agent)
  end

  context "when the action is modify finance users" do
    let(:permitted_roles) { %w[finance_super] }

    it_behaves_like "allows only the permitted roles", false, :modify_user, User.new(role: :finance)
  end

  # reports and exports

  context "when the action is view DEFRA quarterly reports" do
    let(:permitted_roles) do
      %w[
        agency_super
        cbd_user
        developer
      ]
    end

    it_behaves_like "allows only the permitted roles", false, :read, Reports::DefraQuarterlyStatsService
  end

  context "when the action is view bulk email exports" do
    let(:permitted_roles) do
      %w[
        cbd_user
        developer
      ]
    end

    it_behaves_like "allows only the permitted roles", false, :read, DeregistrationEmailExportService
  end

  context "when the action is run finance reports" do
    let(:permitted_roles) do
      %w[
        cbd_user
        developer
        finance_super
      ]
    end

    it_behaves_like "allows only the permitted roles", false, :run_finance_reports, :all
  end

  # other

  context "when the action is toggle features" do
    let(:permitted_roles) { %w[developer] }

    it_behaves_like "allows only the permitted roles", false, :manage, WasteCarriersEngine::FeatureToggle
  end

  context "when the action is import conviction data" do
    let(:permitted_roles) do
      %w[
        developer
        cbd_user
      ]
    end

    it_behaves_like "allows only the permitted roles", false, :import_conviction_data, :all
  end
end
