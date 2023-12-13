# frozen_string_literal: true

class CopyCardsBankTransferFormsController < WasteCarriersEngine::FormsController
  def new
    return unless super(CopyCardsBankTransferForm, "copy_cards_bank_transfer_form")

    set_up_finance_details
  end

  def create
    super(CopyCardsBankTransferForm, "copy_cards_bank_transfer_form")
  end

  private

  def set_up_finance_details
    @transient_registration.prepare_for_payment(:bank_transfer, current_user)
  end

  def authorize_user
    authorize! :order_copy_cards, @resource
  end
end
