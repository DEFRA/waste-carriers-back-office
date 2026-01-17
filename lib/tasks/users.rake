# frozen_string_literal: true

namespace :users do
  desc "Deactivate inactive users"
  # Run with: bundle exec rake deactivate_inactive_users[dry_run]
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

    users_to_deactivate.each { |user| deactivate_user(user, dry_run) }
  end

  desc "Fix signed in accounts with expired invitations"
  task fix_signed_in_accounts_with_expired_invitations: :environment do
    find_users_with_expired_invitations.each do |user|
      clear_invitation_token(user)
    end
  end
end

def deactivate_user(user, dry_run)
  if dry_run
    puts "Currently in dry run mode. Would deactivate user #{user.email}" unless Rails.env.test?
  else
    puts "Deactivating user #{user.email}" unless Rails.env.test?
    user.update(active: false)
  end
end

def find_users_with_expired_invitations
  User.where(
    active: true,
    sign_in_count: { "$gt": 0 },
    invitation_accepted_at: nil,
    invitation_sent_at: { "$lt": User.invite_for.ago }
  )
end

def clear_invitation_token(user)
  puts "Clearing invitation for user #{user.email}" unless Rails.env.test?
  user.invitation_token = nil
  user.invitation_created_at = nil
  user.invitation_sent_at = nil
  user.save!
end
