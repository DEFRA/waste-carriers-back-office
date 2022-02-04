# frozen_string_literal: true

# This collection tracks card order export files as they are genrerated and accessed
module WasteCarriersEngine
  class CardOrdersExportLog
    include Mongoid::Document

    field :exported_at, type:     DateTime
    field :export_filename, type: String

    def initialize(filename)
      super()
      self.export_filename = filename
      self.exported_at = DateTime.now
    end
  end
end
