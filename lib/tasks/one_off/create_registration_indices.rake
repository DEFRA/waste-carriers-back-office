# frozen_string_literal: true

namespace :one_off do
  desc "Create registration indices"
  task create_registration_indices: :environment do
    # Creating these individually through the Ruby driver rather than using the standard 'rake db:create_indexes'
    # because the latter falls over handling mongoid-locker. Ref https://github.com/mongoid/mongoid-locker/issues/91
    WasteCarriersEngine::Registration.collection.indexes.create_one(regIdentifier: 1)
    WasteCarriersEngine::Registration.collection.indexes.create_one(accountEmail: 1)
    WasteCarriersEngine::Registration.collection.indexes.create_one(contactEmail: 1)
    WasteCarriersEngine::Registration.collection.indexes.create_one(companyName: 1)
    WasteCarriersEngine::Registration.collection.indexes.create_one(registeredCompanyName: 1)
    WasteCarriersEngine::Registration.collection.indexes.create_one(firstName: 1)
    WasteCarriersEngine::Registration.collection.indexes.create_one(lastName: 1)
    WasteCarriersEngine::Registration.collection.indexes.create_one(phoneNumber: 1)
    WasteCarriersEngine::Registration.collection.indexes.create_one("addresses.postcode": 1)
  end
end
