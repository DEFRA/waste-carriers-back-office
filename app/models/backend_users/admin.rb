# frozen_string_literal: true

module BackendUsers
  class Admin
    include Mongoid::Document
    include CanBehaveLikeUser

    # Use the User database
    store_in client: "users", collection: "admins"
  end
end
