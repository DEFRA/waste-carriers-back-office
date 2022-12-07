# frozen_string_literal: true

class SearchEmailService < BaseSearchService

  private

  def search(model)
    model.where("$or": [{ contact_email: @term }, { account_email: @term }])
         .limit(100)
         .read(mode: :secondary)
  end
end
