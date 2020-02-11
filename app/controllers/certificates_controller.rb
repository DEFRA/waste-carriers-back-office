# frozen_string_literal: true

class CertificatesController < ApplicationController
  include CanRenderPdf

  def show
    registration = WasteCarriersEngine::Registration.find_by(reg_identifier: params[:registration_reg_identifier])
    @presenter = WasteCarriersEngine::CertificatePresenter.new(registration, view_context)

    render pdf: registration.reg_identifier,
           show_as_html: show_as_html?,
           layout: false,
           page_size: "A4",
           margin: { top: "10mm", bottom: "10mm", left: "10mm", right: "10mm" },
           print_media_type: true,
           template: "waste_carriers_engine/pdfs/certificate"
  end
end
