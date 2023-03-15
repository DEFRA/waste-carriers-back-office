# frozen_string_literal: true

class EmailExportsListsController < ApplicationController
  include CanListFilesOnAws

  before_action :authorize_user

  def new
    render :new, locals: { email_exports: email_exports }
  end

  private

  def authorize_user
    authorize! :read, DeregistrationEmailExportService, current_user
  end

  def email_exports
    EmailExportLog.all.to_a
  end
end
