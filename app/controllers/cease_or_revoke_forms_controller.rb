# frozen_string_literal: true

class CeaseOrRevokeFormsController < BackOfficeFormsController

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

  def authorize_user
    authorize! :cease, WasteCarriersEngine::Registration
    authorize! :revoke, WasteCarriersEngine::Registration
  end
end
