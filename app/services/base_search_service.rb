# frozen_string_literal: true

class BaseSearchService < ::WasteCarriersEngine::BaseService
  def run(page:, term:)
    return response_hash([]) if term.blank?

    @page = page
    @term = term.strip.downcase

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
    @_search_results ||= matching_resources.sort_by do |resource|
      resource.reg_identifier || ""
    end
  end

  def matching_resources
    # De-duplicate results for each class by reg_identifier
    search(WasteCarriersEngine::Registration).uniq(&:reg_identifier) +
      search(WasteCarriersEngine::RenewingRegistration).uniq(&:reg_identifier)
  end
end
