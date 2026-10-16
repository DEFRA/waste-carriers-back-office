# frozen_string_literal: true

require "rails_helper"

RSpec.describe "MongoDB index tasks", type: :task do
  subject(:invoke_task) { Rake.application[task_name].invoke(model_name, index_arg) }

  include_context "rake"

  let(:model_name) { "WasteCarriersEngine::Registration" }
  let(:index_path) { "financeDetails.payments.govpay_id" }
  let(:collection) { WasteCarriersEngine::Registration.collection }

  # Listing indexes fails if the collection does not exist yet
  before { WasteCarriersEngine::Registration.create_collection }

  after { Rake.application[task_name].reenable }

  RSpec.shared_examples "aborts with" do |message|
    it "aborts with #{message.inspect}" do
      expect { invoke_task }.to raise_error(SystemExit).and output(message).to_stderr
    end
  end

  RSpec.shared_examples "validates the model and index arguments" do |task|
    context "without a model_name" do
      let(:model_name) { nil }

      it_behaves_like "aborts with", /Usage: rake #{task}/
    end

    context "without an index argument" do
      let(:index_arg) { nil }

      it_behaves_like "aborts with", /Usage: rake #{task}/
    end

    context "with an unknown model_name" do
      let(:model_name) { "WasteCarriersEngine::NotAModel" }

      it_behaves_like "aborts with", /is not a Mongoid model/
    end

    context "with a model_name that is not a Mongoid model" do
      let(:model_name) { "Kernel" }

      it_behaves_like "aborts with", /is not a Mongoid model/
    end
  end

  describe "db:add_mongodb_index" do
    let(:task_name) { "db:add_mongodb_index" }
    let(:index_arg) { index_path }
    let(:index_keys) { collection.indexes.pluck("key") }

    it_behaves_like "validates the model and index arguments", "db:add_mongodb_index"

    %w[financeDetails..payments .govpay_id govpay_id. $where financeDetails.pay-ments].each do |invalid_path|
      context "when the index_path is #{invalid_path}" do
        let(:index_path) { invalid_path }

        it_behaves_like "aborts with", /Invalid index_path/
      end
    end

    context "when the index does not exist" do
      # DatabaseCleaner deletes documents but not indexes, so drop it to keep runs independent
      after { collection.indexes.drop_one("#{index_path}_1") }

      it "creates the index on the specified model and path" do
        expect { invoke_task }.to output.to_stdout
        expect(index_keys).to include(index_path => 1)
      end

      it "reports the name of the created index" do
        expect { invoke_task }.to output(/Created index 'financeDetails.payments.govpay_id_1' on registrations/).to_stdout
      end

      it "reports how to remove the index" do
        expect { invoke_task }.to output(
          /rake "db:remove_mongodb_index\[#{model_name},financeDetails.payments.govpay_id_1\]"/
        ).to_stdout
      end
    end

    context "when the index already exists" do
      before { collection.indexes.create_one({ index_path => 1 }) }
      after { collection.indexes.drop_one("#{index_path}_1") }

      it_behaves_like "aborts with", /already exists/
    end
  end

  describe "db:remove_mongodb_index" do
    let(:task_name) { "db:remove_mongodb_index" }
    let(:index_arg) { index_name }
    let(:index_name) { "financeDetails.payments.govpay_id_1" }
    let(:index_names) { collection.indexes.pluck("name") }

    it_behaves_like "validates the model and index arguments", "db:remove_mongodb_index"

    context "when the index exists" do
      before { collection.indexes.create_one({ index_path => 1 }, name: index_name) }

      it "drops the index from the specified model" do
        expect { invoke_task }.to output(/Dropped index '#{Regexp.escape(index_name)}'/).to_stdout
        expect(index_names).not_to include(index_name)
      end

      context "with a custom name" do
        let(:index_name) { "custom_index_name" }

        it "drops the index with that name" do
          expect { invoke_task }.to output(/Dropped index 'custom_index_name'/).to_stdout
          expect(index_names).not_to include(index_name)
        end
      end
    end

    context "when the index does not exist" do
      it_behaves_like "aborts with", /No index named 'financeDetails.payments.govpay_id_1'/
    end

    context "when the index_name is _id_" do
      let(:index_name) { "_id_" }

      it_behaves_like "aborts with", /cannot be removed/

      it "keeps the _id_ index" do
        expect { invoke_task }.to raise_error(SystemExit).and output.to_stderr
        expect(index_names).to include("_id_")
      end
    end
  end
end
