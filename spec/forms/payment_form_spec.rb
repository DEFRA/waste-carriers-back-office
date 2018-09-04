# frozen_string_literal: true

require "rails_helper"

RSpec.describe PaymentForm, type: :model do
  let(:payment_form) { build(:payment_form) }
  let(:transient_registration) do
    WasteCarriersEngine::TransientRegistration.where(reg_identifier: payment_form.reg_identifier).first
  end

  describe "#submit" do
    context "when the form is valid" do
      let(:valid_params) do
        {
          reg_identifier: payment_form.reg_identifier,
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

      it "should submit" do
        expect(payment_form.submit(valid_params, payment_type)).to eq(true)
      end

      it "should create a new payment" do
        payment_count = transient_registration.finance_details.payments.count
        payment_form.submit(valid_params, payment_type)
        new_payment_count = transient_registration.reload.finance_details.payments.count

        expect(new_payment_count).to eq(payment_count + 1)
      end

      it "should add the correct amount to the payment" do
        expected_amount = valid_params[:amount] * 100
        payment_form.submit(valid_params, payment_type)

        payment = transient_registration.finance_details.payments.last
        expect(payment.amount).to eq(expected_amount)
      end

      it "should add the correct payment_type to the payment" do
        payment_form.submit(valid_params, payment_type)

        payment = transient_registration.finance_details.payments.last
        expect(payment.payment_type).to eq(payment_type)
      end

      it "should add the correct order_key to the payment" do
        payment_form.submit(valid_params, payment_type)

        payment = transient_registration.reload.finance_details.payments.last
        order = transient_registration.reload.finance_details.orders.last
        expect(payment.order_key).to eq(order.order_code)
      end

      it "should add the correct values from params to the payment" do
        payment_form.submit(valid_params, payment_type)

        payment = transient_registration.finance_details.payments.last
        expect(payment.comment).to eq(valid_params[:comment])
      end

      it "should correctly format the date" do
        expected_date = Date.new(payment_form.date_received_year,
                                 payment_form.date_received_month,
                                 payment_form.date_received_day)
        payment_form.submit(valid_params, payment_type)

        payment = transient_registration.finance_details.payments.last
        expect(payment.date_received).to eq(expected_date)
      end

      context "when a payment already exists" do
        before do
          transient_registration.finance_details.update_attributes(payments: [build(:payment)])
        end

        it "should create an additional payment" do
          payment_count = transient_registration.finance_details.payments.count
          payment_form.submit(valid_params, payment_type)
          new_payment_count = transient_registration.reload.finance_details.payments.count

          expect(new_payment_count).to eq(payment_count + 1)
        end
      end
    end

    context "when the form is not valid" do
      let(:invalid_params) do
        {
          reg_identifier: payment_form.reg_identifier
        }
      end
      let(:payment_type) { "FOO" }

      it "should not submit" do
        expect(payment_form.submit(invalid_params, payment_type)).to eq(false)
      end

      it "should not create a new payment" do
        payment_count = transient_registration.finance_details.payments.count
        payment_form.submit(invalid_params, payment_type)
        new_payment_count = transient_registration.reload.finance_details.payments.count

        expect(new_payment_count).to eq(payment_count)
      end
    end
  end

  describe "#amount" do
    context "when it is zero" do
      before do
        payment_form.amount = 0
      end

      it "is not valid" do
        expect(payment_form).to_not be_valid
      end
    end

    context "when it is not a number" do
      before do
        payment_form.amount = "foo"
      end

      it "is not valid" do
        expect(payment_form).to_not be_valid
      end
    end
  end

  describe "#comment" do
    context "when it is more than 250 characters" do
      before do
        payment_form.comment = "Q2HK0PM50AZ8QWEQL6ZVR7A2SLL5QBQ9T6ZQQ7SU793YOSLABX4SAWMM3OE1LGH8Z6MJK92GEP3F9WR89IY7OUQN1PTU9NHFHSUHA1L6ELJI749QH9UXAKVD9CCGX344692OISGGLMAT4VLDAHOEST6N3KD5093AE9C2RHZD12TUPW0FHRR7JJSQRZM3XJ1FCQQJX9UXG7HW258Y71RDUQQ2UNOX4G1IO5J0JE3GQHH46ENQDT4JX89TSJGT"
      end

      it "is not valid" do
        expect(payment_form).to_not be_valid
      end
    end
  end

  describe "#date_received" do
    context "when it is nil" do
      before do
        payment_form.date_received = nil
      end

      it "is not valid" do
        expect(payment_form).to_not be_valid
      end
    end
  end

  describe "#registration_reference" do
    context "when it is nil" do
      before do
        payment_form.registration_reference = nil
      end

      it "is not valid" do
        expect(payment_form).to_not be_valid
      end
    end
  end
end
