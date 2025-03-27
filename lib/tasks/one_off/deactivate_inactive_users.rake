# frozen_string_literal: true

namespace :one_off do
  desc "Deactivate inactive users"
  task :deactivate_inactive_users, [:dry_run] => :environment do |_task, args|
    dry_run = args[:dry_run].to_s.downcase == "dry_run"

    users_to_deactivate = User.where(active: true)
                              .nin(role: %w[agency_super developer])
                              .any_of({ last_sign_in_at: { "$lt" => 3.months.ago } },
                                      { last_sign_in_at: nil })

    users_to_deactivate.each do |user|
      if dry_run
        puts "Currently in dry run mode. Would deactivate user #{user.email}" unless Rails.env.test?
      else
        puts "Deactivating user #{user.email}" unless Rails.env.test?
        user.update(active: false)
      end
    end
  end
end

# run with: bundle exec rake one_off:deactivate_inactive_users[dry_run]
