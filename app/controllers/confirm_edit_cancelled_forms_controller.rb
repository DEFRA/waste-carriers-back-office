# frozen_string_literal: true

class ConfirmEditCancelledFormsController < BackOfficeFormsController
  def new
    super(ConfirmEditCancelledForm, "confirm_edit_cancelled_form")
  end

  def create
    super(ConfirmEditCancelledForm, "confirm_edit_cancelled_form")
  end

  private

  def authorize_user
    authorize! :edit, WasteCarriersEngine::Registration
  end
end
