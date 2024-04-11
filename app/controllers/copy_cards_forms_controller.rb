# frozen_string_literal: true

class CopyCardsFormsController < BackOfficeFormsController

  def new
    super(CopyCardsForm, "copy_cards_form")
  end

  def create
    super(CopyCardsForm, "copy_cards_form")
  end

  private

  def transient_registration_attributes
    params.fetch(:copy_cards_form).permit(:temp_cards)
  end

  # rubocop:disable Naming/MemoizedInstanceVariableName - we're not just memoizing here
  def find_or_initialize_transient_registration(token)
    @transient_registration ||= OrderCopyCardsRegistration.where(reg_identifier: token).first ||
                                OrderCopyCardsRegistration.where(token: token).first ||
                                OrderCopyCardsRegistration.new(reg_identifier: token)
  end
  # rubocop:enable Naming/MemoizedInstanceVariableName

  def authorize_user
    authorize! :order_copy_cards, WasteCarriersEngine::Registration
  end
end
