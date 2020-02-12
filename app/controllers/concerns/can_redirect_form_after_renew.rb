# frozen_string_literal: true

module CanRedirectFormAfterRenew
  extend ActiveSupport::Concern

  included do
    private

    def redirect_after_successful_submit
      if renew_if_possible
        redirect_to resource_finance_details_path(@resource.registration._id)
      else
        redirect_to resource_finance_details_path(@resource._id)
      end
    end
  end
end
