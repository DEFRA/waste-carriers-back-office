# frozen_string_literal: true

require "rails_helper"

RSpec.describe ConvictionImportService do
  let(:run_service) do
    ConvictionImportService.run
  end

  describe "#run" do
    it "runs" do
      expect { run_service }.to_not raise_error
    end
  end
end
