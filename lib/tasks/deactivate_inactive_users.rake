# frozen_string_literal: true

desc "Deactivate inactive users"
task :deactivate_inactive_users, [:dry_run] => :environment do |_task, args|
  dry_run = args[:dry_run].to_s.downcase == "dry_run"

  users_with_old_logins = User.where(active: true)
                              .nin(role: %w[agency_super developer])
                              .where(:last_sign_in_at.lt => 3.months.ago)

  users_with_no_logins = User.where(active: true)
                             .nin(role: %w[agency_super developer])
                             .where(last_sign_in_at: nil)
                             .where(:invitation_created_at.lt => 3.months.ago)

  users_to_deactivate = users_with_old_logins + users_with_no_logins

  users_to_deactivate.each do |user|
    if dry_run
      puts "Currently in dry run mode. Would deactivate user #{user.email}" unless Rails.env.test?
    else
      puts "Deactivating user #{user.email}" unless Rails.env.test?
      user.update(active: false)
    end
  end
end

# Run with: bundle exec rake deactivate_inactive_users[dry_run]
