# frozen_string_literal: true

require "rails_helper"

RSpec.describe StdoutLogger do
  describe ".log" do
    let(:message) { "Test message" }

    context "when in test environment" do
      before do
        allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new("test"))
      end

      it "does not log the message" do
        expect { described_class.log(message) }.not_to output.to_stdout
      end
    end

    context "when not in test environment" do
      before do
        allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new("development"))
      end

      it "logs the message" do
        expect { described_class.log(message) }.to output("#{message}\n").to_stdout
      end
    end
  end
end
