# frozen_string_literal: true

require "rails_helper"

module Reports
  module Boxi
    RSpec.describe SignOffPresenter do
      let(:payment) { double(:payment) }

      subject { described_class.new(payment, nil) }

      describe "#confirmed_at" do
        it "returns a formatted date" do
          allow(payment).to receive(:confirmed_at).and_return(Date.new(2019, 11, 11))

          expect(subject.confirmed_at.to_s).to eq("2019-11-11T00:00Z")
        end
      end
    end
  end
end
