# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Edit payment summary form" do
  describe "/bo/edit-payment/:token" do
    let(:user) { create(:user, role: :agency_super) }
    let(:transient_registration) do
      create(:edit_registration, finance_details: build(:finance_details, :has_paid_order_and_payment))
    end
    let(:path) { "/bo/#{transient_registration.token}/edit-payment" }

    it_behaves_like "a controller that pauses call recording"
  end
end
