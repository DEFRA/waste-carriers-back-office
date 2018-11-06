# frozen_string_literal: true

require "db"
require "time_helpers"

namespace :db do
  namespace :anonymise do
    desc "Anonymise all account and contact email addresses"
    task email: :environment do
      started = Time.now
      anonymiser = Db::AnonymiseEmail.new

      puts "Anonymising all emails for #{anonymiser.counts[:total]} users"
      puts "-------------------------"

      anonymiser.anonymise(true)

      puts "-------------------------"
      puts "Final results"
      puts "Errors: #{anonymiser.counts[:errored]}"
      puts "Updated: #{anonymiser.counts[:processed]}"
      puts "Took #{TimeHelpers.humanise(Time.now - started)} to complete"
    end
  end
end
