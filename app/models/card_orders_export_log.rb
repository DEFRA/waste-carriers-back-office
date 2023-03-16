# frozen_string_literal: true

# This collection tracks card order export files as they are genrerated and accessed
class CardOrdersExportLog
  include Mongoid::Document

  field :start_time, type: DateTime
  field :end_time, type: DateTime
  field :exported_at, type: DateTime
  field :export_filename, type: String
  field :first_visited_by, type: User
  field :first_visited_at, type: DateTime

  def initialize(start_time, end_time, filename, exported_at)
    super()
    self.start_time = start_time
    self.end_time = end_time
    self.export_filename = filename
    self.exported_at = exported_at
  end

  def download_link
    bucket.presigned_url("CARD_ORDERS/#{export_filename}")
  end

  private

  def bucket
    DefraRuby::Aws.get_bucket(bucket_name)
  end

  def bucket_name
    WasteCarriersBackOffice::Application.config.weekly_exports_bucket_name
  end

end
