# frozen_string_literal: true

class DeregistrationEmailExportSerializer < Reports::BaseCsvFileSerializer
  ATTRIBUTES = {
    reg_identifier: "reg_identifier",
    contact_email: "email_address",
    company_name: "company_name",
    first_name: "first_name",
    last_name: "last_name",
    deregistration_link: "deregistration_link"
  }.freeze

  def initialize(file_path, email_type, notify_template_id, batch_size)
    @email_type = email_type
    @notify_template_id = notify_template_id
    @batch_size = batch_size

    super(file_path)
  end

  def to_csv
    super(csv: nil, force_quotes: true)
  end

  private

  def scope
    WasteCarriersEngine::Registration
      .active
      .lower_tier
      .where(
        :contact_email.nin => ["", nil],
        "metaData.dateRegistered": { "$lte": registration_date_cutoff }
      )
      .not_selected_for_email(@notify_template_id)
      .order_by(expires_on: :asc)
      .limit(@batch_size)
  end

  def parse_object(registration)
    presenter = DeregistrationEmailExportPresenter.new(registration)
    row = ATTRIBUTES.map do |key, _value|
      presenter.public_send(key)
    end

    registration.email_history = [] if registration.email_history.blank?
    registration.email_history << { type: @email_type, template_id: @notify_template_id, time: Time.zone.now }
    registration.save!

    row
  end

  def registration_date_cutoff
    cutoff_months = ENV.fetch("DEREGISTRATION_EMAIL_CUTOFF_MONTHS", 12).to_i
    @registration_date_cutoff = cutoff_months.months.ago
  end
end
