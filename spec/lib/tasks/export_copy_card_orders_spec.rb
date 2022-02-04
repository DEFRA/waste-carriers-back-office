# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Export copy card orders task", type: :rake do
  include_context "rake"

  describe "reports:export:weekly_copy_card_orders" do
    it "runs without error" do
      expect_any_instance_of(Reports::CardOrdersExportService).to receive(:run)
      expect { subject.invoke }.not_to raise_error
    end
  end
end
