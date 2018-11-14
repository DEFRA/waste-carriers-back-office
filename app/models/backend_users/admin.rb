# frozen_string_literal: true

class BackendUsers::Admin
  include Mongoid::Document
  include CanBehaveLikeUser

  # Use the User database
  store_in client: "users", collection: "admins"
end
