module External
  class CertificatesController < ActionController::Base
    include CanHandleErrors
    layout "application"

    def show
      if session[:valid_email]
        registration = find_registration
        @presenter = WasteCarriersEngine::CertificateGeneratorService.run(registration: registration,
                                                                        requester: current_user, view: view_context)
      else
        redirect_to registration_external_certificate_confirm_email_path(params[:registration_reg_identifier])
      end
    end

  def pdf
    registration = find_registration
    @presenter = WasteCarriersEngine::CertificateGeneratorService.run(registration: registration,
                                                                      requester: OpenStruct.new(email: session[:valid_email]), view: view_context)

    render pdf: registration.reg_identifier,
           layout: false,
           page_size: "A4",
           margin: { top: "10mm", bottom: "10mm", left: "10mm", right: "10mm" },
           print_media_type: true,
           template: "waste_carriers_engine/pdfs/certificate",
           enable_local_file_access: true,
           allow: [WasteCarriersEngine::Engine.root.join("app", "assets", "images", "environment_agency_logo.png").to_s]
  end

    def confirm_email
      reset_session if Rails.env.development? # remove before merging
      @registration = find_registration
    end

    def process_email
      @registration = find_registration
      email = params[:email]
      if valid_email?(email)
        session[:valid_email] = email
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
