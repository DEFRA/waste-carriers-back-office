# frozen_string_literal: true

class TransientRegistrationSearchService
  def initialize(term, in_progress, pending_payment, pending_conviction_check)
    @term = term

    @in_progress = in_progress
    @pending_payment = pending_payment
    @pending_conviction_check = pending_conviction_check
  end

  def search(page)
    return WasteCarriersEngine::TransientRegistration.none if no_search_terms_or_filters?

    # The criteria when add results in a AND search (not an OR). So for a
    # renewal to be returned it must match all criteria selected. In some cases
    # this would be impossible, for example `pending_payment` filters on
    # renewals that have been submitted with a balance != 0. If you also
    # selected `in_progress` then you'd get nothing because a renewal can't be
    # both.
    #
    # Also note the way criteria works in mongoid is that until we actually
    # attempt to access a renewal e.g. with `.first` or ``.each` criteria is
    # just a hash of filters. So when we're merging here we are merging filters
    # not selected renewals!
    criteria = WasteCarriersEngine::TransientRegistration.order_by("metaData.lastModified": :desc)
    criteria.merge!(WasteCarriersEngine::TransientRegistration.search_term(@term)) if @term.present?

    criteria.merge!(WasteCarriersEngine::TransientRegistration.in_progress) if @in_progress
    criteria.merge!(WasteCarriersEngine::TransientRegistration.pending_payment) if @pending_payment
    criteria.merge!(WasteCarriersEngine::TransientRegistration.pending_approval) if @pending_conviction_check

    criteria.page(page).read(mode: :secondary)
  end

  private

  def no_search_terms_or_filters?
    return false if @term.present?
    return false if @in_progress || @pending_payment || @pending_conviction_check

    true
  end

end
