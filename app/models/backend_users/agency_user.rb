# frozen_string_literal: true

class BackendUsers::AgencyUser
  include Mongoid::Document
  include CanBehaveLikeUser

  # Use the User database
  store_in client: "users", collection: "agency_users"
end
