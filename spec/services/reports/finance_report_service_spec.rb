# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe FinanceReportsService do

    # Tests for the structure and content of the report are in the serializer_spec.
    describe ".run" do

      subject { described_class.new }

      # Clean up the test /tmp area after generating the files
      after(:each) { FileUtils.rm_rf(Pathname.new(subject.report_file_path).dirname.to_s) }

      it "generates a report file" do
        subject.run

        expect(File.exist?(subject.report_file_path)).to be true
      end
    end
  end
end
