# frozen_string_literal: true

class SearchService < BaseSearchService

  private

  def search(model)
    model.search_term(@term)
         .limit(100)
         .read(mode: :secondary)
  end
end
