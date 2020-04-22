# frozen_string_literal: true

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Learn more: http://github.com/javan/whenever

log_output_path = ENV["EXPORT_SERVICE_CRON_LOG_OUTPUT_PATH"] || "/srv/ruby/waste-carriers-back-office/shared/log/"
set :output, File.join(log_output_path, "whenever_cron.log")
set :job_template, "/bin/bash -l -c 'eval \"$(rbenv init -)\" && :job'"

# Only one of the AWS app servers has a role of "db"
# see https://gitlab-dev.aws-int.defra.cloud/open/rails-deployment/blob/master/config/deploy.rb#L69
# so only creating cronjobs on that server, otherwise all jobs would be duplicated everyday!

# This is the EPR export job. When run this will create a single CSV file of all
# active exemptions and put this into an AWS S3 bucket from which the company
# that provides and maintains the Electronis Public Register will grab it
every :day, at: (ENV["EXPORT_SERVICE_EPR_EXPORT_TIME"] || "21:05"), roles: [:db] do
  rake "reports:export:epr"
end

# This is the first renewal email reminder job. For each registration expiring
# in 28 days time, it will generate and send the first email reminder
every :day, at: (ENV["FIRST_RENEWAL_EMAIL_REMINDER_DAILY_RUN_TIME"] || "02:05"), roles: [:db] do
  rake "email:renew_reminder:first:send"
end

# This is the second renewal email reminder job. For each registration expiring
# in 7 days time, it will generate and send the second email reminder
every :day, at: (ENV["SECOND_RENEWAL_EMAIL_REMINDER_DAILY_RUN_TIME"] || "04:05"), roles: [:db] do
  rake "email:renew_reminder:second:send"
end

# This is the BOXI export job. When run this will generate a zip file of CSV's,
# each of which contains the data from the WCR database table e.g. registrations
# to registrations.csv, addresses to addresses.csv. This is then uploaded to AWS
# S3 from where it is grabbed by a process that imports it into the WCR BOXI
# universe
every :day, at: (ENV["EXPORT_SERVICE_BOXI_EXPORT_TIME"] || "22:00"), roles: [:db] do
  rake "reports:export:boxi"
end

# This is the registration exemptions expiry job which will collect all active upper tier
# registrations that have an expiry date in the past and will set their state to `EXPIRED`s
every :day, at: (ENV["EXPIRE_REGISTRATION_EXEMPTION_RUN_TIME"] || "20:00"), roles: [:db] do
  rake "expire_registration:run"
end
