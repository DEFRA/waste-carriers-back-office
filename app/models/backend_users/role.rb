# frozen_string_literal: true

class BackendUsers::Role
  include Mongoid::Document

  # Use the User database
  store_in client: "users", collection: "roles"

  field :name,            type: String
  field :resource_type,   type: String
  field :resource_id,     type: String
  field :agency_user_ids, type: Hash
end
