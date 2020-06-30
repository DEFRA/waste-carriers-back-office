# frozen_string_literal: true

class LettersController < ApplicationController
  def index
    authorize! :manage, FinalReminderLettersExport
  end
end
