# frozen_string_literal: true

module Reports
  class UserExportSerializer < BaseSerializer
    ATTRIBUTES = {
      email: "Email Address",
      status: "Status",
      role: "Role",
      current_sign_in_at: "Last Logged In",
      invitation_accepted_at: "Invitation Accepted"
    }.freeze

    private

    def scope
      User.all
    end

    def parse_object(user)
      presenter = Reports::UserPresenter.new(user)

      ATTRIBUTES.map do |key, _value|
        presenter.public_send(key)
      end
    end
  end
end
