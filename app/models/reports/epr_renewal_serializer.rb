# frozen_string_literal: true

module Reports
  class EprRenewalSerializer < EprSerializer

    private

    def scope
      ::WasteCarriersEngine::RenewingRegistration
        .where("conviction_sign_offs.confirmed": "no", :"metaData.status".ne => "REVOKED")
        .select { |rr| rr.pending_manual_conviction_check? && !rr.pending_payment? }
    end

    def already_processed(reg_identifier)
      return true if @processed_ids.include?(reg_identifier)

      @processed_ids << reg_identifier

      false
    end
  end
end
