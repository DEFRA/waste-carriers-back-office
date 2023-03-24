# frozen_string_literal: true

class DeregistrationEmailExportSerializer < Reports::BaseCsvFileSerializer
  DATA_ATTRIBUTES = {
    regIdentifier: "reg_identifier",
    contactEmail: "email_address",
    companyName: "company_name",
    firstName: "first_name",
    lastName: "last_name"
  }.freeze

  ATTRIBUTES = DATA_ATTRIBUTES.merge({ deregistration_link: "deregistration_link" }).freeze

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
    WasteCarriersEngine::Registration.collection.aggregate(
      [
        { "$match": {
          "metaData.status": "ACTIVE",
          tier: "LOWER",
          contactEmail: { "$exists": true, "$type": 2, "$ne": "" },
          "metaData.dateRegistered": { "$lte": registration_date_cutoff },
          "email_history.template_id": { "$nin": [@notify_template_id] }
        } },
        { "$sort": { "metaData.dateRegistered": 1 } },
        { "$limit": @batch_size },
        { "$project": DATA_ATTRIBUTES.keys.index_with { 1 } }
      ],
      { allow_disk_use: true }
    )
  end

  def parse_object(registration_bson)
    registration = WasteCarriersEngine::Registration.find_by(reg_identifier: registration_bson[:regIdentifier])
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
