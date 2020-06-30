# frozen_string_literal: true

class FinalReminderLettersExport
  include Mongoid::Document
  include Mongoid::Timestamps

  STATES = [
    SUCCEDED = "succeded",
    FAILED = "failed",
    DELETED = "deleted"
  ].freeze

  store_in collection: "final_reminder_letters_exports"

  validates :expires_on, uniqueness: true

  scope :not_deleted, -> { where.not(status: DELETED) }

  field :expires_on, type: Date
  field :file_name, type: String
  field :number_of_letters, type: Integer
  field :printed_by, type: String
  field :printed_on, type: Date
  field :status, type: String, default: SUCCEDED

  def export!
    FinalReminderLettersExportService.run(self)
  end

  def printed?
    printed_on.present? && printed_by.present?
  end

  def presigned_aws_url
    bucket.presigned_url(file_name)
  end

  def deleted!
    bucket.delete(file_name)

    update(status: DELETED)
  end

  def deleted?
    status == DELETED
  end

  def succeded?
    status == SUCCEDED
  end

  def succeded!
    update(status: SUCCEDED)
  end

  def failed?
    status == FAILED
  end

  def failed!
    update(status: FAILED)
  end

  private

  def bucket
    @_bucket ||= DefraRuby::Aws.get_bucket(bucket_name)
  end

  def bucket_name
    WasteCarriersBackOffice::Application.config.letters_export_bucket_name
  end
end
