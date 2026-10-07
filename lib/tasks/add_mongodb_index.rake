# frozen_string_literal: true

namespace :db do
  desc "Add an ascending MongoDB index, " \
       "e.g. rake db:add_mongodb_index[WasteCarriersEngine::Registration,financeDetails.payments.govpay_id]"
  task :add_mongodb_index, %i[model_name index_path] => :environment do |_task, args|
    if args[:model_name].blank? || args[:index_path].blank?
      abort "Usage: rake db:add_mongodb_index[model_name,index_path]\n" \
            "\twhere model_name is fully qualified, e.g. 'WasteCarriersEngine::Registration'\n" \
            "\tand index_path is the index path from the model, e.g. 'financeDetails.payments.govpay_id'"
    end

    model = args[:model_name].safe_constantize
    abort "#{args[:model_name]} is not a Mongoid model" unless model.is_a?(Class) && model.include?(Mongoid::Document)

    index_path = args[:index_path]
    # Dot-separated field names, e.g. financeDetails.payments.govpay_id
    abort "Invalid index_path: #{index_path}" unless index_path.match?(/\A[A-Za-z_]\w*(\.[A-Za-z_]\w*)*\z/)

    if model.collection.indexes.get(index_path => 1)
      abort "Index on #{index_path} already exists for #{model.collection.name}"
    end

    name = model.collection.indexes.create_one({ index_path => 1 })

    puts "Created index #{name} on #{model.collection.name}"
  end
end
