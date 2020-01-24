# frozen_string_literal: true

module WasteCarriersEngine
  module JourneyLinksHelper
    def renewal_finished_link(reg_identifier:)
      main_app.renewing_registration_path(reg_identifier: reg_identifier)
    end
  end
end
