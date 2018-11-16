# frozen_string_literal: true

class TransientRegistrationFinderService
  def initialize(term, in_progress, pending_payment, pending_conviction_check)
    @term = term

    @in_progress = in_progress
    @pending_payment = pending_payment
    @pending_conviction_check = pending_conviction_check
  end

  def find(page)
    return WasteCarriersEngine::TransientRegistration.none if no_search_terms_or_filters?

    criteria = WasteCarriersEngine::TransientRegistration.order_by("metaData.lastModified": :desc)
    criteria.merge!(WasteCarriersEngine::TransientRegistration.search_term(@term)) if @term.present?

    criteria.merge!(WasteCarriersEngine::TransientRegistration.in_progress) if @in_progress
    criteria.merge!(WasteCarriersEngine::TransientRegistration.pending_payment) if @pending_payment
    criteria.merge!(WasteCarriersEngine::TransientRegistration.pending_approval) if @pending_conviction_check

    criteria.page(page)
  end

  private

  def no_search_terms_or_filters?
    return false if @term.present?
    return false if @in_progress || @pending_payment || @pending_conviction_check

    true
  end

end
