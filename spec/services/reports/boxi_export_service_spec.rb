# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe BoxiExportService do
    describe ".run" do
      it "generates a zip file and upload it to AWS" do
        temp_dir = Dir.mktmpdir
        zipfile = double(:zipfile)
        bucket = double(:bucket)
        result = double(:result)
        file_path = File.join(temp_dir, "test_file.csv")

        # populate test dir
        File.open(file_path, "w")

        expect(GenerateBoxiFilesService).to receive(:run).with(temp_dir)
        allow(Dir).to receive(:mktmpdir).and_yield(temp_dir)
        allow(Zip::File).to receive(:open).and_yield(zipfile)
        expect(zipfile).to receive(:add).with("test_file.csv", file_path)
        allow(DefraRuby::Aws).to receive(:get_bucket).and_return(bucket)
        expect(File).to receive(:new)
        allow(bucket).to receive(:load).and_return(result)
        expect(result).to receive(:successful?).and_return(true).twice

        # expect no errors
        expect(Airbrake).not_to receive(:notify)
        expect(Rails.logger).not_to receive(:error)

        described_class.run
      end

      context "when an error happens" do
        it "raises an error" do
          allow(Dir).to receive(:mktmpdir).and_raise("An error!")

          expect(Airbrake).to receive(:notify)
          expect(Rails.logger).to receive(:error)

          described_class.run
        end
      end
    end
  end
end
