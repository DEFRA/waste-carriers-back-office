# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Copy cards payment form" do
  describe "/bo/order-copy-cards-payment/:token" do
    let(:user) { create(:user, role: :agency_super) }
    let(:transient_registration) { create(:new_registration) }
    let(:path) { "/bo/#{transient_registration.token}/order-copy-cards-payment" }

    it_behaves_like "a controller that pauses call recording"
  end
end
