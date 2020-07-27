# frozen_string_literal: true

class CancelsController < ApplicationController
  include CanFetchResource
  include CanSetFlashMessages
  include FinanceDetailsHelper

  prepend_before_action :authenticate_user!
  before_action :authorize_user

  def new; end

  def create
    @resource.metaData.cancel
    @resource.save!

    flash_success(
      I18n.t("cancels.messages.success", reg_identifier: @resource.reg_identifier)
    )

    redirect_to details_path_for(@resource)
  end

  private

  def authorize_user
    authorize! :cancel, WasteCarriersEngine::Registration
  end
end
