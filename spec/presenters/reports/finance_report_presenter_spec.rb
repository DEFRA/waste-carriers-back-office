# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe FinanceReportPresenter do

    let(:row) do
      {
        period: "20220912",
        year: "2022",
        month: "09",
        day: "12",
        balance: Faker::Number.number(digits: 4),
        renewals_due: Faker::Number.number(digits: 2),
        renewal_percent: Faker::Number.between(from: 0.0, to: 1.0),
        payments: {
          count: Faker::Number.number(digits: 2),
          balance: Faker::Number.number(digits: 4),
          cash: {
            count: Faker::Number.number(digits: 2),
            total: Faker::Number.number(digits: 4)
          },
          reversal: {
            count: Faker::Number.number(digits: 2),
            total: Faker::Number.number(digits: 4)
          },
          postalorder: {
            count: Faker::Number.number(digits: 2),
            total: Faker::Number.number(digits: 4)
          },
          refund: {
            count: Faker::Number.number(digits: 2),
            total: Faker::Number.number(digits: 4)
          },
          govpay: {
            count: Faker::Number.number(digits: 2),
            total: Faker::Number.number(digits: 4)
          },
          worldpay: {
            count: Faker::Number.number(digits: 2),
            total: Faker::Number.number(digits: 4)
          },
          worldpaymissed: {
            count: Faker::Number.number(digits: 2),
            total: Faker::Number.number(digits: 4)
          },
          cheque: {
            count: Faker::Number.number(digits: 2),
            total: Faker::Number.number(digits: 4)
          },
          banktransfer: {
            count: Faker::Number.number(digits: 2),
            total: Faker::Number.number(digits: 4)
          },
          writeoffsmall: {
            count: Faker::Number.number(digits: 2),
            total: Faker::Number.number(digits: 4)
          },
          writeofflarge: {
            count: Faker::Number.number(digits: 2),
            total: Faker::Number.number(digits: 4)
          }
        },
        charges: {
          count: Faker::Number.number(digits: 2),
          balance: Faker::Number.number(digits: 4),
          chargeadjust: {
            count: Faker::Number.number(digits: 2),
            total: Faker::Number.number(digits: 4)
          },
          copycards: {
            count: Faker::Number.number(digits: 2),
            total: Faker::Number.number(digits: 4)
          },
          newreg: {
            count: Faker::Number.number(digits: 2),
            total: Faker::Number.number(digits: 4)
          },
          renew: {
            count: Faker::Number.number(digits: 2),
            total: Faker::Number.number(digits: 4)
          },
          edit: {
            count: Faker::Number.number(digits: 2),
            total: Faker::Number.number(digits: 4)
          },
          irimport: {
            count: Faker::Number.number(digits: 2),
            total: Faker::Number.number(digits: 4)
          }
        }
      }
    end

    subject { described_class.new(row) }

    it "presents monetary amounts as pounds and pence" do
      expect(subject.balance).to eq format("%<val>.2f", val: row[:balance] / 100.0)
      expect(subject.pay_bal).to eq format("%<val>.2f", val: row[:payments][:balance] / 100.0)
      expect(subject.pay_cash_tot).to eq format("%<val>.2f", val: row[:payments][:cash][:total] / 100.0)
      expect(subject.pay_reversal_tot).to eq format("%<val>.2f", val: row[:payments][:reversal][:total] / 100.0)
      expect(subject.pay_postalorder_tot).to eq format("%<val>.2f", val: row[:payments][:postalorder][:total] / 100.0)
      expect(subject.pay_refund_tot).to eq format("%<val>.2f", val: row[:payments][:refund][:total] / 100.0)
      expect(subject.pay_govpay_tot).to eq format("%<val>.2f", val: row[:payments][:govpay][:total] / 100.0)
      expect(subject.pay_worldpay_tot).to eq format("%<val>.2f", val: row[:payments][:worldpay][:total] / 100.0)
      expect(subject.pay_worldpaymissed_tot).to eq format("%<val>.2f", val: row[:payments][:worldpaymissed][:total] / 100.0)
      expect(subject.pay_cheque_tot).to eq format("%<val>.2f", val: row[:payments][:cheque][:total] / 100.0)
      expect(subject.pay_banktransfer_tot).to eq format("%<val>.2f", val: row[:payments][:banktransfer][:total] / 100.0)
      expect(subject.pay_writeoffsmall_tot).to eq format("%<val>.2f", val: row[:payments][:writeoffsmall][:total] / 100.0)
      expect(subject.pay_writeofflarge_tot).to eq format("%<val>.2f", val: row[:payments][:writeofflarge][:total] / 100.0)
      expect(subject.chg_bal).to eq format("%<val>.2f", val: row[:charges][:balance] / 100.0)
      expect(subject.chg_chargeadjust_tot).to eq format("%<val>.2f", val: row[:charges][:chargeadjust][:total] / 100.0)
      expect(subject.chg_copycards_tot).to eq format("%<val>.2f", val: row[:charges][:copycards][:total] / 100.0)
      expect(subject.chg_new_tot).to eq format("%<val>.2f", val: row[:charges][:newreg][:total] / 100.0)
      expect(subject.chg_renew_tot).to eq format("%<val>.2f", val: row[:charges][:renew][:total] / 100.0)
      expect(subject.chg_edit_tot).to eq format("%<val>.2f", val: row[:charges][:edit][:total] / 100.0)
      expect(subject.chg_irimport_tot).to eq format("%<val>.2f", val: row[:charges][:irimport][:total] / 100.0)
    end

    it "presents percentage amounts in the correct format" do
      expect(subject.renewal_percent).to eq format("%<val>2.1f%%", val: row[:renewal_percent] * 100.0)
    end
  end
end
