# frozen_string_literal: true

class CertificatesController < ApplicationController
  include CanRenderPdf

  def show
    registration = WasteCarriersEngine::Registration.find_by(reg_identifier: params[:registration_reg_identifier])
    @presenter = WasteCarriersEngine::CertificateGeneratorService.run(registration: registration,
                                                                      requester: current_user, view: view_context)

    render pdf: registration.reg_identifier,
           show_as_html: show_as_html?,
           layout: false,
           page_size: "A4",
           margin: { top: "10mm", bottom: "10mm", left: "10mm", right: "10mm" },
           print_media_type: true,
           template: "waste_carriers_engine/pdfs/certificate",
           enable_local_file_access: true,
           allow: [WasteCarriersEngine::Engine.root.join("app", "assets", "images", "environment_agency_logo.png").to_s]
  end
end
