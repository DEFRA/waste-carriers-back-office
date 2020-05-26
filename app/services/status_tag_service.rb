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

  # Metadata status

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
    return :in_progress if transient_new?
    return :in_progress unless @resource.renewal_application_submitted?
  end

  def reg_metadata_status
    return :in_progress if @resource.metaData.PENDING?

    @resource.metaData.status.downcase.to_sym
  end

  # Conviction checks

  def pending_conviction_check
    :pending_conviction_check if registration_or_submitted_renewal? && @resource.pending_manual_conviction_check?
  end

  # Payments

  def pending_payment
    :pending_payment if registration_or_submitted_renewal? && @resource.pending_payment?
  end

  # Stuck

  def stuck
    :stuck if transient_renewal? && @resource.stuck?
  end

  # Helper methods

  def transient?
    @_transient ||= @resource.is_a?(WasteCarriersEngine::TransientRegistration)
  end

  def transient_renewal?
    @_transient_renewal ||= @resource.is_a?(WasteCarriersEngine::RenewingRegistration)
  end

  def transient_new?
    @_transient_new ||= @resource.is_a?(WasteCarriersEngine::NewRegistration)
  end

  def submitted_renewal?
    @_submitted_renewal ||= transient_renewal? && @resource.renewal_application_submitted?
  end

  def registration_or_submitted_renewal?
    @_registration_or_submitted_renewal ||= submitted_renewal? || !transient?
  end
end
