# frozen_string_literal: true

require "rails_helper"

# This is an integration test.
# Since is not easy to integration testing AWS exported files, this is the highest entry point
# in the functionality which allow us to integration test the BOXI export feature
module Reports
  RSpec.describe GenerateBoxiFilesService do
    describe ".run" do
      it "generates CSV files for the boxi exports in a given folder" do
        create(:registration, :has_orders_and_payments, :has_flagged_conviction_check)

        temp_dir = Dir.mktmpdir

        described_class.run(temp_dir)

        # Test addresses file gets created
        addresses_file_path = File.join(temp_dir, "addresses.csv")

        expect(File.exist?(addresses_file_path)).to be(true)
        file_lines = File.readlines(addresses_file_path)
        expect(file_lines.count).to be >= 2

        # Test key_people file gets created
        key_people_path = File.join(temp_dir, "key_people.csv")

        expect(File.exist?(key_people_path)).to be(true)
        file_lines = File.readlines(key_people_path)
        expect(file_lines.count).to be >= 2

        # Test order_items file gets created
        order_items_path = File.join(temp_dir, "order_items.csv")

        expect(File.exist?(order_items_path)).to be(true)
        file_lines = File.readlines(order_items_path)
        expect(file_lines.count).to be >= 2

        # Test order file gets created
        orders_path = File.join(temp_dir, "orders.csv")

        expect(File.exist?(orders_path)).to be(true)
        file_lines = File.readlines(orders_path)
        expect(file_lines.count).to be >= 2

        # Test payments file gets created
        orders_path = File.join(temp_dir, "payments.csv")

        expect(File.exist?(orders_path)).to be(true)
        file_lines = File.readlines(orders_path)
        expect(file_lines.count).to be >= 2

        # Test registrations file gets created
        registrations_path = File.join(temp_dir, "registrations.csv")

        expect(File.exist?(registrations_path)).to be(true)
        file_lines = File.readlines(registrations_path)
        expect(file_lines.count).to be >= 2

        # Test sign_offs file gets created
        sign_offs_path = File.join(temp_dir, "sign_offs.csv")

        expect(File.exist?(sign_offs_path)).to be(true)
        file_lines = File.readlines(sign_offs_path)
        expect(file_lines.count).to be >= 2
      end
    end
  end
end
