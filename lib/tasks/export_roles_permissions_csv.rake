# frozen_string_literal: true

require "csv"

# rubocop:disable Metrics/BlockLength
namespace :debug do
  desc "export a matrix of all permissions for all user roles"
  task export_roles_permissions: :environment do

    resource_actions = [
      { cancel: WasteCarriersEngine::Registration },
      { cease: WasteCarriersEngine::Registration },
      { charge_adjust: WasteCarriersEngine::Registration },
      { create: WasteCarriersEngine::Registration },
      { edit: WasteCarriersEngine::Registration },
      { import_conviction_data: User },
      { manage: WasteCarriersEngine::FeatureToggle },
      { manage_back_office_users: User },
      { order_copy_cards: WasteCarriersEngine::Registration },
      { record_bank_transfer_payment: WasteCarriersEngine::Registration },
      { record_cash_payment: WasteCarriersEngine::Registration },
      { record_cheque_payment: WasteCarriersEngine::Registration },
      { record_missed_card_payment: WasteCarriersEngine::Registration },
      { record_postal_order_payment: WasteCarriersEngine::Registration },
      { read: DeregistrationEmailExportService },
      { read: Reports::DefraQuarterlyStatsService },
      { refresh_company_name: WasteCarriersEngine::Registration },
      { refund: WasteCarriersEngine::Registration },
      { renew: WasteCarriersEngine::Registration },
      { resend_confirmation_email: WasteCarriersEngine::Registration },
      { restore: WasteCarriersEngine::Registration },
      { revert_to_payment_summary: WasteCarriersEngine::Registration },
      { reverse: WasteCarriersEngine::Payment.new(payment_type: :bank_transfer) },
      { reverse: WasteCarriersEngine::Payment.new(payment_type: :cash) },
      { reverse: WasteCarriersEngine::Payment.new(payment_type: :cheque) },
      { reverse: WasteCarriersEngine::Payment.new(payment_type: :govpay) },
      { reverse: WasteCarriersEngine::Payment.new(payment_type: :postal_order) },
      { review_convictions: User },
      { revoke: WasteCarriersEngine::Registration },
      { run_finance_reports: User },
      { update: WasteCarriersEngine::RenewingRegistration },
      { view_card_order_exports: User },
      { view_certificate: WasteCarriersEngine::Registration },
      { view_payments: User },
      { view_revoked_reasons: User },
      { write_off_large: WasteCarriersEngine::FinanceDetails },
      { write_off_small: WasteCarriersEngine::FinanceDetails }
    ]
    resource_actions += User::ROLES.map { |role| { modify_user: User.new(role: role) } }

    users = User::ROLES.map { |role| User.new(role: role) }

    file_path = Rails.root.join("tmp/roles_permissions_#{Time.zone.now.strftime('%Y-%m-%d_%H-%M-%S')}.csv")
    CSV.open(file_path, "w", force_quotes: false) do |csv|

      csv << (["", "action", "resource type / role"] + users.pluck(:role))

      row_number = 1
      resource_actions.each do |resource_action|
        resource_action.each do |action, resource|
          resource_label = case resource
                           when User
                             resource.role
                           when WasteCarriersEngine::Payment
                             resource.payment_type
                           else
                             resource
                           end
          row = [row_number, action, resource_label]
          users.each do |user|
            row << (user.can?(action, resource) ? "Y" : "")
          end
          csv << row
          row_number += 1
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
