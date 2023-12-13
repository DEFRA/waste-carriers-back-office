# frozen_string_literal: true

class CeaseOrRevokeFormsController < WasteCarriersEngine::FormsController
  prepend_before_action :authenticate_user!

  def new
    super(CeaseOrRevokeForm, "cease_or_revoke_form")
  end

  def create
    super(CeaseOrRevokeForm, "cease_or_revoke_form")
  end

  private

  def transient_registration_attributes
    params.fetch(:cease_or_revoke_form).permit(metaData: %i[status revoked_reason])
  end

  # rubocop:disable Naming/MemoizedInstanceVariableName
  def find_or_initialize_transient_registration(token)
    @transient_registration ||= CeasedOrRevokedRegistration.where(reg_identifier: token).first ||
                                CeasedOrRevokedRegistration.where(token: token).first ||
                                CeasedOrRevokedRegistration.new(reg_identifier: token)
  end
  # rubocop:enable Naming/MemoizedInstanceVariableName
end
