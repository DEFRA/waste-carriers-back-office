# frozen_string_literal: true

require "db"
require "time_helpers"

namespace :db do
  namespace :anonymise do
    # This task can take a long time to complete and therefore you may prefer
    # to run it as a background task using
    # nohup bundle exec rake db:anonymise:email > anonymise.out 2>&1 </dev/null &
    desc "Anonymise all account and contact email addresses"
    task email: :environment do
      STDOUT.sync = true

      started = Time.now
      anonymiser = Db::AnonymiseEmail.new

      puts "Anonymising all emails for #{anonymiser.counts[:total]} users"
      puts "-------------------------"

      anonymiser.anonymise(false)

      puts "\n-------------------------"
      puts "Final results"
      puts "Skipped: #{anonymiser.counts[:skipped]}"
      puts "Updated: #{anonymiser.counts[:processed]}"
      puts "Errors: #{anonymiser.counts[:errored]}"
      puts "Took #{TimeHelpers.humanise(Time.now - started)} to complete"
    end
  end
end
