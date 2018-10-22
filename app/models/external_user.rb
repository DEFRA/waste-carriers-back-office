# frozen_string_literal: true

class ExternalUser
  include Mongoid::Document
  include CanBehaveLikeUser

  # Use the User database
  store_in client: "users", collection: "users"
end
