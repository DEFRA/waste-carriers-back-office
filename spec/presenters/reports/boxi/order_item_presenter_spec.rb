# frozen_string_literal: true

require "rails_helper"

module Reports
  module Boxi
    RSpec.describe OrderItemPresenter do
      let(:order_item) { double(:order_item) }

      subject { described_class.new(order_item, nil) }

      describe "#last_updated" do
        it "returns the date as a formatted string" do
          last_updated = Time.new(2019, 11, 19)

          expect(order_item).to receive(:last_updated).and_return(last_updated)
          expect(subject.last_updated.to_s).to eq("2019-11-19T00:00Z")
        end
      end
    end
  end
end
