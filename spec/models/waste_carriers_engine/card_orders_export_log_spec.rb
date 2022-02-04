# frozen_string_literal: true

require "rails_helper"

module WasteCarriersEngine
  RSpec.describe CardOrdersExportLog, type: :model do
    let(:export_filename) { Faker::File.file_name }

    subject { described_class.new(export_filename) }

    describe "#initialize" do
      it "records the time of the export" do
        expect(subject.exported_at).to be_within(2.seconds).of(DateTime.now)
      end

      it "records the export filename" do
        expect(subject.export_filename).to eq export_filename
      end
    end

  end

end
