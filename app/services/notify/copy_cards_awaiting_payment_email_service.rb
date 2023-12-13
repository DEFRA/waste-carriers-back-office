# frozen_string_literal: true

module Notify
  class CopyCardsAwaitingPaymentEmailService < WasteCarriersEngine::Notify::BaseSendEmailService
    def run(registration:, order:)
      @order = order
      super
    end

    private

    def notify_options
      presenter = OrderCopyCardsMailerPresenter.new(@registration, @order)

      {
        email_address: @registration.contact_email,
        template_id: "56997dd9-852f-4e18-b4e2-c008a9398bfe",
        personalisation: {
          reg_identifier: @registration.reg_identifier,
          first_name: @registration.first_name,
          last_name: @registration.last_name,
          total_cards: presenter.total_cards,
          ordered_on: presenter.ordered_on_formatted_string,
          payment_due: display_pence_as_pounds(presenter.payment_due),
          sort_code: payment_details(:sort_code),
          account_number: payment_details(:account_number)
        }
      }
    end

    def payment_details(key)
      I18n.t("waste_carriers_engine.payment_details.#{key}")
    end
  end
end
