# frozen_string_literal: true

class SearchEmailService < BaseSearchService

  private

  def search(model)
    model.where(contact_email: /\A#{Regexp.escape(@term)}\z/i)
         .limit(100)
         .read(mode: :secondary)
  end
end
