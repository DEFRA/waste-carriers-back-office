# frozen_string_literal: true

class DeregistrationEmailExportPresenter < WasteCarriersEngine::BasePresenter

  def deregistration_link
    WasteCarriersEngine::DeregistrationMagicLinkService.run(registration: self)
  end
end
