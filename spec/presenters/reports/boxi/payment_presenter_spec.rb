# frozen_string_literal: true

require "rails_helper"

module Reports
  module Boxi
    RSpec.describe PaymentPresenter do
      let(:payment) { double(:payment) }

      subject { described_class.new(payment, nil) }

      describe "#date_received" do
        it "returns a formatted date" do
          expect(payment).to receive(:date_received).and_return(Date.new(2019, 11, 11))

          expect(subject.date_received).to eq("2019-11-11T00:00Z")
        end
      end

      describe "#date_entered" do
        it "returns a formatted date" do
          expect(payment).to receive(:date_entered).and_return(Date.new(2019, 11, 11))

          expect(subject.date_entered).to eq("2019-11-11T00:00Z")
        end
      end
    end
  end
end
