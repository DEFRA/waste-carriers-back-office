# frozen_string_literal: true

class EditBankTransferFormsController < WasteCarriersEngine::FormsController
  def new
    return unless super(EditBankTransferForm, "edit_bank_transfer_form")

    set_up_finance_details
  end

  def create
    super(EditBankTransferForm, "edit_bank_transfer_form")
  end

  private

  def set_up_finance_details
    @transient_registration.prepare_for_payment(:bank_transfer, current_user)
  end
end
