# frozen_string_literal: true

require "rails_helper"

module Reports
  module Boxi
    RSpec.describe OrderPresenter do
      let(:order) { double(:order) }

      subject { described_class.new(order, nil) }

      describe "#date_created" do
        it "returns the date as a formatted string" do
          date_created = Time.new(2019, 11, 19)

          expect(order).to receive(:date_created).and_return(date_created)
          expect(subject.date_created.to_s).to eq("2019-11-19T00:00Z")
        end
      end

      describe "#date_last_updated" do
        it "returns the date as a formatted string" do
          date_last_updated = Time.new(2019, 11, 19)

          expect(order).to receive(:date_last_updated).and_return(date_last_updated)
          expect(subject.date_last_updated.to_s).to eq("2019-11-19T00:00Z")
        end
      end
    end
  end
end
