# frozen_string_literal: true

namespace :one_off do
  desc "Rename import_convictions_data role"
  task rename_import_convictions_role: :environment do
    convictions_users = User.where(role: :import_convictions_data)
    puts "Updating #{convictions_users.count} \"import_convictions_data\" user roles to \"cbd_user\""
    convictions_users.update_all(role: :cbd_user)
  end
end
