# frozen_string_literal: true

module Db
  def self.registrations_collection
    Mongoid::Clients.default.database.collections.find { |c| c.name == "registrations" }
  end

  def self.transient_registrations_collection
    Mongoid::Clients.default.database.collections.find { |c| c.name == "transient_registrations" }
  end

  def self.users_collection
    Mongoid::Clients.with_name("users").database.collections.find { |c| c.name == "users" }
  end

  def self.paged_users(paging)
    users_collection
      .find
      .skip(paging[:page_size] * (paging[:page_number] - 1))
      .limit(paging[:page_size])
  end

  def self.counts(collection)
    counts = {
      total: 0,
      processed: 0,
      errored: 0
    }
    counts[:total] = collection.find.count

    counts
  end

  def self.paging(total, size)
    {
      page_size: size,
      page_number: 1,
      num_of_pages: (total / size.to_f).ceil
    }
  end
end
