# frozen_string_literal: true

module Reports
  class UserPresenter < WasteCarriersEngine::BasePresenter
    DATETIME_FORMAT = Time::DATE_FORMATS[:day_month_year_time_slashes]

    def initialize(model)
      @user = model
      super(model)
    end

    def current_sign_in_at
      @user.current_sign_in_at&.strftime(DATETIME_FORMAT)
    end

    def invitation_accepted_at
      @user.invitation_accepted_at&.strftime(DATETIME_FORMAT)
    end

    def email
      @user.email
    end

    def status
      return "Active" if @user.active?
      return "Invitation Sent" if @user.invitation_sent_at.present?

      "Deactivated"
    end
  end
end
