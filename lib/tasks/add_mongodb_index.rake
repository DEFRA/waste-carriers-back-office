# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
namespace :db do
  # Returns the Mongoid model for model_name, aborting if there isn't one
  find_model = lambda do |model_name|
    model = model_name.safe_constantize
    abort "#{model_name} is not a Mongoid model" unless model.is_a?(Class) && model.include?(Mongoid::Document)

    model
  end

  desc "Add an ascending MongoDB index, " \
       "e.g. rake db:add_mongodb_index[WasteCarriersEngine::Registration,financeDetails.payments.govpay_id]"
  task :add_mongodb_index, %i[model_name index_path] => :environment do |_task, args|
    if args[:model_name].blank? || args[:index_path].blank?
      abort "Usage: rake db:add_mongodb_index[model_name,index_path]\n" \
            "\twhere model_name is fully qualified, e.g. 'WasteCarriersEngine::Registration'\n" \
            "\tand index_path is the index path from the model, e.g. 'financeDetails.payments.govpay_id'"
    end

    model = find_model.call(args[:model_name])

    index_path = args[:index_path]
    # Dot-separated field names, e.g. financeDetails.payments.govpay_id
    abort "Invalid index_path: #{index_path}" unless index_path.match?(/\A[A-Za-z_]\w*(\.[A-Za-z_]\w*)*\z/)

    if model.collection.indexes.get(index_path => 1)
      abort "Index on #{index_path} already exists for #{model.collection.name}"
    end

    model.collection.indexes.create_one({ index_path => 1 })
    # create_one returns the command result rather than the index, so look up the name MongoDB assigned
    name = model.collection.indexes.get(index_path => 1)["name"]

    puts "Created index '#{name}' on #{model.collection.name}"
    puts "To remove it: rake \"db:remove_mongodb_index[#{args[:model_name]},#{name}]\""
  end

  desc "Remove a MongoDB index by name, " \
       "e.g. rake db:remove_mongodb_index[WasteCarriersEngine::Registration,financeDetails.payments.govpay_id_1]"
  task :remove_mongodb_index, %i[model_name index_name] => :environment do |_task, args|
    if args[:model_name].blank? || args[:index_name].blank?
      abort "Usage: rake db:remove_mongodb_index[model_name,index_name]\n" \
            "\twhere model_name is fully qualified, e.g. 'WasteCarriersEngine::Registration'\n" \
            "\tand index_name is the name of the index, e.g. 'financeDetails.payments.govpay_id_1'"
    end

    model = find_model.call(args[:model_name])
    index_name = args[:index_name]

    abort "The _id_ index cannot be removed" if index_name == "_id_"

    unless model.collection.indexes.get(index_name)
      abort "No index named '#{index_name}' exists for #{model.collection.name}"
    end

    model.collection.indexes.drop_one(index_name)

    puts "Dropped index '#{index_name}' from #{model.collection.name}"
  end
end
# rubocop:enable Metrics/BlockLength
