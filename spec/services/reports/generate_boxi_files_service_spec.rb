# frozen_string_literal: true

require "rails_helper"

# This is an integration test.
# Since is not easy to integration testing AWS exported files, this is the highest entry point
# in the functionality which allow us to integration test the BOXI export feature
module Reports
  RSpec.describe GenerateBoxiFilesService do
    describe ".run" do
      it "generates CSV files for the boxi exports in a given folder" do
        create(:registration)

        temp_dir = Dir.mktmpdir

        described_class.run(temp_dir)

        # Test addresses file gets created
        addresses_file_path = File.join(temp_dir, "addresses.csv")

        expect(File.exist?(addresses_file_path)).to be_truthy
        expect(File.read(addresses_file_path)).to_not be_empty

        # TODO
        # Test key_people file gets created
        # Test order_items file gets created
        # Test order file gets created
        # Test payments file gets created
        # Test registrations file gets created
        # Test sign_offs file gets created
      end
    end
  end
end
