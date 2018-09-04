# frozen_string_literal: true

class PaymentForm < WasteCarriersEngine::BaseForm
  attr_accessor :amount, :comment, :current_user_email, :date_received, :date_received_day, :date_received_month,
                :date_received_year, :order_key, :payment_type, :registration_reference, :payment, :finance_details

  def submit(params, payment_type_value)
    # Assign the params for validation and pass them to the BaseForm method for updating
    self.amount = params[:amount]
    self.comment = params[:comment]
    # TODO: Add this value to params before calling submit
    self.current_user_email = params[:current_user_email]
    self.order_key = params[:order_key]
    self.payment_type = payment_type_value
    self.registration_reference = params[:registration_reference]

    process_date_fields(params)
    set_date_received

    self.payment = build_payment
    self.finance_details = update_finance_details

    attributes = { finance_details: finance_details }

    super(attributes, params[:reg_identifier])
  end

  validates :date_received, presence: true

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

  def build_payment
    payment = WasteCarriersEngine::Payment.new

    payment.amount = amount
    payment.comment = comment
    payment.registration_reference = registration_reference
    payment.payment_type = payment_type
    payment.currency = "GBP"

    payment.date_received_day = date_received_day
    payment.date_received_month = date_received_month
    payment.date_received_year = date_received_year
    payment.date_received = date_received

    payment.updated_by_user = current_user_email

    payment
  end

  def update_finance_details
    copy_finance_details

    if finance_details.payments.present?
      finance_details.payments << payment
    else
      finance_details.payments = [payment]
    end

    finance_details
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
