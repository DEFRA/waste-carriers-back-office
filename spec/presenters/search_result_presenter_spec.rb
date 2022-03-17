# frozen_string_literal: true

require "rails_helper"

RSpec.describe SearchResultPresenter do
  let(:presenter) { described_class.new(model) }

  describe "#entity_display_name" do
    let(:model) { Object.new }

    it { expect(presenter).to respond_to(:entity_display_name) }
  end

  describe "#is_a? WasteCarriersEngine::NewRegistration" do
    subject { presenter.is_a?(WasteCarriersEngine::NewRegistration) }

    context "when the model is a WasteCarriersEngine::NewRegistration" do
      let(:model) { WasteCarriersEngine::NewRegistration.new }

      it { expect(subject).to be_truthy }
    end

    context "when the model is not a WasteCarriersEngine::Registration" do
      let(:model) { WasteCarriersEngine::RenewingRegistration.new }

      it { expect(subject).to be_falsey }
    end
  end
end
