# frozen_string_literal: true

require "rails_helper"

RSpec.describe BasePaymentForm, type: :model do
  let(:payment_form) { build(:base_payment_form) }
  let(:transient_registration) do
    WasteCarriersEngine::RenewingRegistration.where(reg_identifier: payment_form.reg_identifier).first
  end

  describe "#submit" do
    context "when the form is valid" do
      let(:valid_params) do
        {
          amount: payment_form.amount,
          comment: payment_form.comment,
          updated_by_user: payment_form.updated_by_user,
          registration_reference: payment_form.registration_reference,
          date_received_day: payment_form.date_received_day,
          date_received_month: payment_form.date_received_month,
          date_received_year: payment_form.date_received_year
        }
      end
      let(:payment_type) { "FOO" }

      it "submits" do
        expect(payment_form.submit(valid_params, payment_type)).to be(true)
      end

      it "creates a new payment" do
        payment_count = transient_registration.finance_details.payments.count
        payment_form.submit(valid_params, payment_type)
        new_payment_count = transient_registration.reload.finance_details.payments.count

        expect(new_payment_count).to eq(payment_count + 1)
      end

      it "adds  the correct amount to the payment" do
        expected_amount = valid_params[:amount] * 100
        payment_form.submit(valid_params, payment_type)

        payment = transient_registration.finance_details.payments.last
        expect(payment.amount).to eq(expected_amount)
      end

      it "adds  the correct payment_type to the payment" do
        payment_form.submit(valid_params, payment_type)

        payment = transient_registration.finance_details.payments.last
        expect(payment.payment_type).to eq(payment_type)
      end

      it "adds  the correct values from params to the payment" do
        payment_form.submit(valid_params, payment_type)

        payment = transient_registration.finance_details.payments.last
        expect(payment.comment).to eq(valid_params[:comment])
      end

      it "updates the finance_details balance" do
        expected_balance = transient_registration.finance_details.balance - valid_params[:amount] * 100
        payment_form.submit(valid_params, payment_type)

        expect(transient_registration.reload.finance_details.balance).to eq(expected_balance)
      end

      it "correctly formats the date" do
        expected_date = Date.new(payment_form.date_received_year,
                                 payment_form.date_received_month,
                                 payment_form.date_received_day)
        payment_form.submit(valid_params, payment_type)

        payment = transient_registration.finance_details.payments.last
        expect(payment.date_received).to eq(expected_date)
      end

      context "when a payment already exists" do
        before do
          transient_registration.finance_details.update(payments: [build(:payment)])
        end

        it "creates an additional payment" do
          payment_count = transient_registration.finance_details.payments.count
          payment_form.submit(valid_params, payment_type)
          new_payment_count = transient_registration.reload.finance_details.payments.count

          expect(new_payment_count).to eq(payment_count + 1)
        end
      end
    end

    context "when the form is not valid" do
      let(:invalid_params) { {} }
      let(:payment_type) { "FOO" }

      it "does not submit and does not create a new payment" do
        payment_count = transient_registration.finance_details.payments.count

        expect(payment_form.submit(invalid_params, payment_type)).to be(false)

        new_payment_count = transient_registration.reload.finance_details.payments.count

        expect(new_payment_count).to eq(payment_count)
      end

      context "when the date inserted is in the future" do
        let(:date) { 1.day.from_now }
        let(:params) do
          {
            amount: payment_form.amount,
            comment: payment_form.comment,
            updated_by_user: payment_form.updated_by_user,
            registration_reference: payment_form.registration_reference,
            date_received_day: date.day,
            date_received_month: date.month,
            date_received_year: date.year
          }
        end
        let(:payment_type) { "FOO" }

        it "does not submit and does not create a new payment" do
          payment_count = transient_registration.finance_details.payments.count

          expect(payment_form.submit(params, payment_type)).to be(false)

          new_payment_count = transient_registration.reload.finance_details.payments.count

          expect(new_payment_count).to eq(payment_count)
        end
      end
    end
  end

  describe "#amount" do
    context "when it is zero" do
      before do
        payment_form.amount = 0
      end

      it "is not valid" do
        expect(payment_form).not_to be_valid
      end
    end

    context "when it is not a number" do
      before do
        payment_form.amount = "foo"
      end

      it "is not valid" do
        expect(payment_form).not_to be_valid
      end
    end
  end

  describe "#comment" do
    context "when it is more than 500 characters" do
      before do
        payment_form.comment = "Test " * 101
      end

      it "is not valid" do
        expect(payment_form).not_to be_valid
      end
    end
  end

  describe "#date_received" do
    context "when it is nil" do
      before do
        payment_form.date_received = nil
      end

      it "is not valid" do
        expect(payment_form).not_to be_valid
      end
    end
  end

  describe "#registration_reference" do
    context "when it is nil" do
      before do
        payment_form.registration_reference = nil
      end

      it "is not valid" do
        expect(payment_form).not_to be_valid
      end
    end
  end
end
