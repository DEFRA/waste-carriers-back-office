# frozen_string_literal: true

class OrderPresenter < WasteCarriersEngine::BasePresenter
  def payment_method
    return "-" unless super.present?

    super.titleize
  end
end
