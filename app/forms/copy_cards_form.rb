# frozen_string_literal: true

class CopyCardsForm < WasteCarriersEngine::CardsForm
  def self.can_navigate_flexibly?
    false
  end

  validates(
    :temp_cards,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: MAX_TEMP_CARDS
    }
  )
end
