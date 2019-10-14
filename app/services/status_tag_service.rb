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
    return reg_metadata_status if @resource.is_a?(WasteCarriersEngine::Registration)
    return transient_reg_metadata_status if @resource.is_a?(WasteCarriersEngine::TransientRegistration)
  end

  def reg_metadata_status
    return :in_progress if @resource.metaData.PENDING?

    @resource.metaData.status.downcase.to_sym
  end

  def transient_reg_metadata_status
    return :revoked if @resource.metaData.REVOKED?
    return :refused if @resource.metaData.REFUSED?
    return :in_progress unless submitted_renewal?
  end

  def pending_conviction_check
    return nil unless submitted_renewal?

    :pending_conviction_check if @resource.pending_manual_conviction_check?
  end

  def pending_payment
    return nil unless submitted_renewal?

    :pending_payment if @resource.pending_payment?
  end

  def stuck
    return nil unless submitted_renewal?

    :stuck if @resource.stuck?
  end

  def submitted_renewal?
    @_submitted_renewal ||= @resource.is_a?(WasteCarriersEngine::TransientRegistration) &&
                            @resource.renewal_application_submitted?
  end
end
