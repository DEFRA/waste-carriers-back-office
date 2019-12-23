# frozen_string_literal: true

require "rails_helper"

# This is an integration test.
# Since is not easy to integration testing AWS exported files, this is the highest entry point
# in the functionality which allow us to integration test the BOXI export feature
module Reports
  RSpec.describe GenerateBoxiFilesService do
    describe ".run" do
      it "generates CSV files for the boxi exports in a given folder" do
        create(:registration, :has_orders_and_payments)

        temp_dir = Dir.mktmpdir

        described_class.run(temp_dir)

        # Test addresses file gets created
        addresses_file_path = File.join(temp_dir, "addresses.csv")

        expect(File.exist?(addresses_file_path)).to be_truthy
        expect(File.read(addresses_file_path)).to_not be_empty

        # Test key_people file gets created
        key_people_path = File.join(temp_dir, "key_people.csv")

        expect(File.exist?(key_people_path)).to be_truthy
        expect(File.read(key_people_path)).to_not be_empty

        # Test order_items file gets created
        order_items_path = File.join(temp_dir, "order_items.csv")

        expect(File.exist?(order_items_path)).to be_truthy
        expect(File.read(order_items_path)).to_not be_empty

        # Test order file gets created
        orders_path = File.join(temp_dir, "orders.csv")

        expect(File.exist?(orders_path)).to be_truthy
        expect(File.read(orders_path)).to_not be_empty

        # Test payments file gets created
        orders_path = File.join(temp_dir, "payments.csv")

        expect(File.exist?(orders_path)).to be_truthy
        expect(File.read(orders_path)).to_not be_empty

        # Test registrations file gets created
        registrations_path = File.join(temp_dir, "registrations.csv")

        expect(File.exist?(registrations_path)).to be_truthy
        expect(File.read(registrations_path)).to_not be_empty

        # TODO
        # Test sign_offs file gets created
      end
    end
  end
end
