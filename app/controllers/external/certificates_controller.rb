module External
  class CertificatesController < ActionController::Base
    include CanHandleErrors
    layout "application"

    def show
      registration = WasteCarriersEngine::Registration.find_by(reg_identifier: params[:registration_reg_identifier])
      @presenter = WasteCarriersEngine::CertificateGeneratorService.run(registration: registration,
                                                                        requester: current_user, view: view_context)

    end
  end
end
