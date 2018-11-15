# frozen_string_literal: true

module BackendUsers
  class AgencyUser
    include Mongoid::Document
    include CanBehaveLikeUser

    field :role_ids, type: Array

    # Use the User database
    store_in client: "users", collection: "agency_users"
  end
end
