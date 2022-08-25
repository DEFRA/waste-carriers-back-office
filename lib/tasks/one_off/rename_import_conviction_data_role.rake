# frozen_string_literal: true

namespace :one_off do
  desc "Rename import_conviction_data role"
  task rename_import_conviction_data_role: :environment do
    convictions_users = User.where(role: :import_conviction_data)
    puts "Updating #{convictions_users.count} \"import_conviction_data\" user roles to \"cbd_user\""
    convictions_users.update_all(role: :cbd_user)
  end
end
