# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe DeregistrationEmailExportPresenter do

    subject(:presenter) { described_class.new(registration) }

    let(:registration) { create(:registration) }
    let(:magic_link) { Faker::Internet.url }

    describe "#deregistration_link" do

      before { allow(WasteCarriersEngine::DeregistrationMagicLinkService).to receive(:run).and_return magic_link }

      it "returns a valid link" do
        expect(presenter.deregistration_link).to eq(magic_link)
      end
    end
  end
end
