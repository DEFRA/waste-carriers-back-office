# frozen_string_literal: true

namespace :one_off do
  desc "Create registration unsubscribe_token index"
  task create_unsubscribe_token_index: :environment do
    WasteCarriersEngine::Registration.collection.indexes.create_one(unsubscribe_token: 1)
  end
end
