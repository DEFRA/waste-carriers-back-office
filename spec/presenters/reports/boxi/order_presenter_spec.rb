# frozen_string_literal: true

require "rails_helper"

module Reports
  module Boxi
    RSpec.describe OrderPresenter do
      let(:order) { double(:order) }

      subject { ::Reports::Boxi::OrderPresenter.new(order, nil) }

      describe "#date_created" do
        it "returns the date as a formatted string" do
          date_created = Time.zone.local(2019, 11, 19)

          expect(order).to receive(:date_created).and_return(date_created)
          expect(subject.date_created.to_s).to eq("2019-11-19T00:00Z")
        end
      end

      describe "#date_last_updated" do
        it "returns the date as a formatted string" do
          date_last_updated = Time.zone.local(2019, 11, 19)

          expect(order).to receive(:date_last_updated).and_return(date_last_updated)
          expect(subject.date_last_updated.to_s).to eq("2019-11-19T00:00Z")
        end
      end

      describe "#total_amount" do
        it "returns the amount in pounds" do
          amount = 500

          allow(order).to receive(:total_amount).and_return(amount)

          expect(subject.total_amount).to eq("5.00")
        end
      end
    end
  end
end
