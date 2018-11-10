# frozen_string_literal: true

require "db"
require "users"

namespace :users do
  desc "Sync backend users with back-office"
  task sync_internal_users: :environment do
    sync_users = Users::SyncUsers.new
    sync_users.sync
  end
end
