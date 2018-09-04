# frozen_string_literal: true

class PaymentForm < WasteCarriersEngine::BaseForm
  attr_accessor :amount, :comment, :date_received, :date_received_day, :date_received_month, :date_received_year,
                :order_key, :payment_type, :registration_reference, :updated_by_user,
                :finance_details, :order, :payment

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

    build_payment(params)
    update_finance_details

    attributes = { finance_details: finance_details }

    super(attributes, params[:reg_identifier])
  end

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :comment, length: { maximum: 250 }
  validates :date_received, presence: true
  validates :registration_reference, presence: true

  private

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
    return integer_value if integer_value.positive?
  end

  def set_date_received
    self.date_received = Date.new(date_received_year, date_received_month, date_received_day)
  rescue NoMethodError
    errors.add(:date_received, :invalid_date)
  rescue ArgumentError
    errors.add(:date_received, :invalid_date)
  rescue TypeError
    errors.add(:date_received, :invalid_date)
  end

  def build_payment(params)
    self.payment = WasteCarriersEngine::Payment.new_from_non_worldpay(params, order)
  end

  def update_finance_details
    copy_finance_details

    if finance_details.payments.present?
      finance_details.payments << payment
    else
      finance_details.payments = [payment]
    end
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
