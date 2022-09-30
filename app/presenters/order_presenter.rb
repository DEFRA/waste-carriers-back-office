# frozen_string_literal: true

class OrderPresenter < WasteCarriersEngine::BasePresenter
  def payment_method
    return "-" if super.blank?

    super.titleize
  end
end
