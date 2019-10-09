# frozen_string_literal: true

class TransientRegistrationSearchService < ::WasteCarriersEngine::BaseService
  def run(page:, term:)
    return [] if term.blank?

    WasteCarriersEngine::TransientRegistration.search_term(term)
                                              .order_by("metaData.lastModified": :desc)
                                              .page(page)
                                              .read(mode: :secondary)
  end
end
