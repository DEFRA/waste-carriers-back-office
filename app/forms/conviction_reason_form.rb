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
end
