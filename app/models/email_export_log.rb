# frozen_string_literal: true

class EmailExportLog
  include Mongoid::Document

  field :exported_at, type: DateTime
  field :export_filename, type: String
  field :download_log, type: Array, default: []

  def initialize(filename, exported_at)
    super()
    self.export_filename = filename
    self.exported_at = exported_at
  end

  def download_link
    bucket.presigned_url("EMAIL_EXPORTS/#{export_filename}")
  end

  private

  def bucket
    DefraRuby::Aws.get_bucket(WasteCarriersBackOffice::Application.config.email_exports_bucket_name)
  end

end
