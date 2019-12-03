# frozen_string_literal: true

class BaseConvictionPresenter < WasteCarriersEngine::BasePresenter
  def conviction_status_message
    if conviction_sign_offs.first.present?
      I18n.t(".convictions.index.status.#{conviction_sign_offs.first.workflow_state}")
    else
      I18n.t(".convictions.index.status.not_required")
    end
  end
end
