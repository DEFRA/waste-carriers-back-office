# frozen_string_literal: true

class AdPrivacyPolicyController < ApplicationController
  def show
    @reg_identifier = params[:reg_identifier]
  end
end
