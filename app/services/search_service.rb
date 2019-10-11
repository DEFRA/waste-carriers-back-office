# frozen_string_literal: true

class SearchService < ::WasteCarriersEngine::BaseService
  def run(page:, term:)
    return [] if term.blank?

    @term = term
    Kaminari.paginate_array(combined_results).page(page)
  end

  private

  def combined_results
    search(WasteCarriersEngine::TransientRegistration) + search(WasteCarriersEngine::Registration)
  end

  def search(model)
    model.search_term(@term)
         .order_by("metaData.lastModified": :desc)
         .read(mode: :secondary)
  end
end
