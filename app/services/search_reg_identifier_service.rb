# frozen_string_literal: true

class SearchRegIdentifierService < BaseSearchService

  private

  def search(model)
    model.where(reg_identifier: @term.upcase)
         .limit(100)
         .read(mode: :secondary)
  end
end
