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
    # De-duplicate Registration results by reg_identifier
    # and TransientRegistration results by reg_identifier and classname.
    search(WasteCarriersEngine::Registration).uniq(&:reg_identifier) +
      search(WasteCarriersEngine::TransientRegistration).uniq { |reg| "#{reg.reg_identifier}_#{reg.class}" }
  end

  # Implement this in the subclasses
  def search(model)
    raise NotImplementedError
  end
end
