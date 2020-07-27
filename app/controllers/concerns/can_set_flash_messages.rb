# frozen_string_literal: true

module CanSetFlashMessages
  extend ActiveSupport::Concern

  def flash_success(message)
    flash[:success] = message
  end

  def flash_message(message)
    flash[:message] = message
  end

  def flash_error(error, description)
    flash[:error] = error
    flash[:error_details] = description
  end
end
