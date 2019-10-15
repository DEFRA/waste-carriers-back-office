# frozen_string_literal: true

class StatusTagService < ::WasteCarriersEngine::BaseService
  def run(resource:)
    return [] if resource.blank?

    @resource = resource

    tags = []
    tags << metadata_status
    tags << pending_conviction_check
    tags << pending_payment
    tags << stuck

    tags.compact
  end

  private

  def metadata_status
    return :revoked if @resource.metaData.REVOKED?
    return :refused if @resource.metaData.REFUSED?

    if transient?
      transient_reg_metadata_status
    else
      reg_metadata_status
    end
  end

  def transient_reg_metadata_status
    return :in_progress unless @resource.renewal_application_submitted?
  end

  def reg_metadata_status
    return :in_progress if @resource.metaData.PENDING?

    @resource.metaData.status.downcase.to_sym
  end

  def pending_conviction_check
    :pending_conviction_check if submitted_renewal? && @resource.pending_manual_conviction_check?
  end

  def pending_payment
    :pending_payment if submitted_renewal? && @resource.pending_payment?
  end

  def stuck
    :stuck if transient? && @resource.stuck?
  end

  def transient?
    @_transient ||= @resource.is_a?(WasteCarriersEngine::TransientRegistration)
  end

  def submitted_renewal?
    @_submitted_renewal ||= transient? && @resource.renewal_application_submitted?
  end
end
