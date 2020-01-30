# frozen_string_literal: true

require "rails_helper"

module Reports
  module Boxi
    RSpec.describe OrdersUidCounter do
      after do
        # Make sure to clean up after each test
        OrdersUidCounter.reset
      end

      describe ".current_count" do
        it "returns the current OrderUID count" do
          expect(described_class.current_count).to eq(described_class.class_variable_get(:@@count))
        end
      end

      describe ".increment" do
        it "increments the value of the class variable" do
          expect(described_class.class_variable_get(:@@count)).to eq(1)

          described_class.increment

          expect(described_class.class_variable_get(:@@count)).to eq(2)
        end
      end

      describe ".reset" do
        it "resets the value of the count class variable to 1" do
          described_class.class_variable_set(:@@count, 5)

          described_class.reset

          expect(described_class.class_variable_get(:@@count)).to eq(1)
        end
      end
    end
  end
end
