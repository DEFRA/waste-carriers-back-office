# frozen_string_literal: true

class CardOrderExportsController < ApplicationController

  before_action :authorize_user

  def index
    @exports = CardOrderExportPresenter.create_from_collection(CardOrdersExportLog.all)
  end

  def show
    export_log = CardOrdersExportLog.find(params[:id])
    if export_log.first_visited_by.blank?
      export_log.first_visited_at = Time.zone.now
      export_log.first_visited_by = current_user.email
      export_log.save!
    end
    redirect_to URI.parse(export_log.download_link).to_s
  end

  private

  def authorize_user
    authorize! :view_card_order_exports, current_user
  end
end
