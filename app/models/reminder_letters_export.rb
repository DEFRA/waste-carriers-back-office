# frozen_string_literal: true

class ReminderLettersExport
  include Mongoid::Document
  include Mongoid::Timestamps

  STATES = [
    SUCCEEDED = "succeeded",
    FAILED = "failed",
    DELETED = "deleted"
  ].freeze

  validates :expires_on, uniqueness: true

  store_in collection: "reminder_letters_exports"

  scope :not_deleted, -> { where.not(status: DELETED) }

  field :expires_on, type: Date
  field :file_name, type: String
  field :number_of_letters, type: Integer
  field :printed_by, type: String
  field :printed_on, type: Date
  field :status, type: String, default: SUCCEEDED

  # Implement in subclasses
  def export!
    raise NotImplementedError
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

  def succeeded?
    status == SUCCEEDED
  end

  def succeeded!
    update(status: SUCCEEDED)
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
