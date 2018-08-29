# frozen_string_literal: true

class ConvictionReasonForm < WasteCarriersEngine::BaseForm
  attr_accessor :revoked_reason, :meta_data

  def submit(params)
    # Assign the params for validation and pass them to the BaseForm method for updating
    self.revoked_reason = params[:revoked_reason]

    self.meta_data = @transient_registration.metaData
    meta_data.revoked_reason = revoked_reason

    attributes = { metaData: meta_data }

    super(attributes, params[:reg_identifier])
  end

  validates :revoked_reason, presence: true
  validate :convictions_not_already_signed_off?

  private

  def convictions_not_already_signed_off?
    if @transient_registration.conviction_check_approved? || @transient_registration.metaData.REVOKED?
      errors.add(:base, :already_signed_off)
      false
    else
      true
    end
  end
end
