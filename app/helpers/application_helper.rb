# frozen_string_literal: true

module ApplicationHelper
  # The admin template assumes this is defined, so chucking it in for now until Devise is installed
  def current_user
    OpenStruct.new(name: "A Test User")
  end
end
