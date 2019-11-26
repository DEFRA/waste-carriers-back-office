# frozen_string_literal: true

class SearchService < ::WasteCarriersEngine::BaseService
  def run(page:, term:)
    return response_hash([]) if term.blank?

    @page = page
    @term = term.strip

    response_hash(search_results)
  end

  private

  def response_hash(results)
    {
      count: results.count,
      results: Kaminari.paginate_array(results).page(@page)
    }
  end

  def search_results
    @_search_results ||= matching_resources.sort_by(&:reg_identifier)
  end

  def matching_resources
    search(WasteCarriersEngine::Registration) + search(WasteCarriersEngine::RenewingRegistration)
  end

  def search(model)
    model.search_term(@term)
         .limit(100)
         .read(mode: :secondary)
  end
end
