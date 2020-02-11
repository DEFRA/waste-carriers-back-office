# frozen_string_literal: true

module CanRenderPdf
  extend ActiveSupport::Concern

  def show_as_html?
    params[:show_as_html] == "true"
  end
end
