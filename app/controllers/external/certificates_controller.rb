module External
  class CertificatesController < ActionController::Base
    include CanHandleErrors
    layout "application"

    def show
      if session[:redirected_from_valid_email]
        registration = find_registration
        @presenter = WasteCarriersEngine::CertificateGeneratorService.run(registration: registration,
                                                                        requester: current_user, view: view_context)
      else
        redirect_to registration_external_certificate_confirm_email_path(params[:registration_reg_identifier])
      end
    end

    def confirm_email
      reset_session # TODO for debugging, please remove
      @registration = find_registration
    end

    def process_email
      @registration = find_registration
      email = params[:email]
      if valid_email?(email)
        session[:redirected_from_valid_email] = true
        redirect_to registration_external_certificate_path(@registration.reg_identifier)
      else
        flash[:error] = "Invalid email address"
        render :confirm_email
      end
    end

    private

    def find_registration
      WasteCarriersEngine::Registration.find_by(reg_identifier: params[:registration_reg_identifier])
    end

    def valid_email?(email)
      [@registration.contact_email, @registration.receipt_email].include?(email)
    end
  end
end
