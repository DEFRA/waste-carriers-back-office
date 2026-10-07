# frozen_string_literal: true

require "rails_helper"

RSpec.describe "db:add_mongodb_index", type: :task do
  subject(:invoke_task) { Rake.application["db:add_mongodb_index"].invoke(model_name, index_path) }

  include_context "rake"

  let(:model_name) { "WasteCarriersEngine::Registration" }
  let(:index_path) { "financeDetails.payments.govpay_id" }
  let(:collection) { WasteCarriersEngine::Registration.collection }
  let(:index_keys) { collection.indexes.pluck("key") }

  after { Rake.application["db:add_mongodb_index"].reenable }

  context "without a model_name" do
    let(:model_name) { nil }

    it "aborts with usage information" do
      expect { invoke_task }.to raise_error(SystemExit).and output(/Usage/).to_stderr
    end
  end

  context "without an index_path" do
    let(:index_path) { nil }

    it "aborts with usage information" do
      expect { invoke_task }.to raise_error(SystemExit).and output(/Usage/).to_stderr
    end
  end

  context "with an unknown model_name" do
    let(:model_name) { "WasteCarriersEngine::NotAModel" }

    it "aborts without creating an index" do
      expect { invoke_task }.to raise_error(SystemExit).and output(/is not a Mongoid model/).to_stderr
    end
  end

  context "with a model_name that is not a Mongoid model" do
    let(:model_name) { "Kernel" }

    it "aborts without creating an index" do
      expect { invoke_task }.to raise_error(SystemExit).and output(/is not a Mongoid model/).to_stderr
    end
  end

  context "with an invalid index_path" do
    %w[financeDetails..payments .govpay_id govpay_id. $where financeDetails.pay-ments].each do |invalid_path|
      context "when the index_path is #{invalid_path}" do
        let(:index_path) { invalid_path }

        it "aborts without creating an index" do
          expect { invoke_task }.to raise_error(SystemExit).and output(/Invalid index_path/).to_stderr
        end
      end
    end
  end

  context "with a model and index_path" do
    # Listing indexes fails if the collection does not exist yet
    before { WasteCarriersEngine::Registration.create_collection }

    # DatabaseCleaner deletes documents but not indexes, so drop it to keep runs independent
    after { collection.indexes.drop_one("#{index_path}_1") }

    context "when the index does not exist" do
      it "creates the index on the specified model and path" do
        expect { invoke_task }.to output(/Created index/).to_stdout
        expect(index_keys).to include(index_path => 1)
      end
    end

    context "when the index already exists" do
      before { collection.indexes.create_one({ index_path => 1 }) }

      it "aborts without recreating the index" do
        expect { invoke_task }.to raise_error(SystemExit).and output(/already exists/).to_stderr
      end
    end
  end
end
