# frozen_string_literal: true

class BasePaymentForm < WasteCarriersEngine::BaseForm
  attr_accessor :amount, :comment, :date_received, :date_received_day, :date_received_month, :date_received_year,
                :order_key, :payment_type, :registration_reference, :updated_by_user,
                :finance_details, :order, :payment

  validates :amount, numericality: { greater_than_or_equal_to: 0.01 }
  validates :comment, length: { maximum: 500 }
  validates :date_received, presence: true, "defra_ruby/validators/past_date": true
  validates :registration_reference, presence: true

  def initialize(transient_registration)
    super
    self.order = transient_registration.finance_details.orders.first
  end

  def submit(params, payment_type_value)
    # Assign the params for validation and pass them to the BaseForm method for updating
    self.amount = params[:amount]
    self.comment = params[:comment]
    self.order_key = order.order_code
    self.payment_type = payment_type_value
    self.registration_reference = params[:registration_reference]
    self.updated_by_user = params[:updated_by_user]

    process_date_fields(params)
    params[:date_received] = set_date_received
    params[:payment_type] = payment_type_value

    return false unless valid?

    build_payment(params)
    update_finance_details

    attributes = { finance_details: finance_details }

    super(attributes)
  end

  private

  def convert_amount_to_pence(amount_in_pounds)
    return amount_in_pounds if amount_in_pounds.blank?

    amount_in_pounds.to_d * 100
  end

  def process_date_fields(params)
    self.date_received_day = format_date_field_value(params[:date_received_day])
    self.date_received_month = format_date_field_value(params[:date_received_month])
    self.date_received_year = format_date_field_value(params[:date_received_year])
  end

  # If we can make the date fields positive integers, use those integers
  # Otherwise, return nil
  def format_date_field_value(value)
    # If this isn't a valid integer, .to_i returns 0
    integer_value = value.to_i
    integer_value if integer_value.positive?
  end

  def set_date_received
    self.date_received = Date.new(date_received_year, date_received_month, date_received_day)
  rescue NoMethodError, ArgumentError, TypeError
    errors.add(:date_received, :invalid_date)
  end

  def build_payment(params)
    params[:amount] = convert_amount_to_pence(params[:amount])

    self.payment = WasteCarriersEngine::Payment.new_from_non_online_payment(params, order)
  end

  def update_finance_details
    copy_finance_details

    if finance_details.payments.present?
      finance_details.payments << payment
    else
      finance_details.payments = [payment]
    end

    finance_details.update_balance
  end

  # Need to copy the finance details, update our copy and then overwrite what's already there when submitting.
  # This is awkward, but Mongo throws a push error otherwise. We do a similar thing for key people.
  def copy_finance_details
    self.finance_details = WasteCarriersEngine::FinanceDetails.new
    existing_finance_details = @transient_registration.reload.finance_details

    finance_details.orders = existing_finance_details.orders
    finance_details.payments = existing_finance_details.payments
    finance_details.balance = existing_finance_details.balance
  end
end
