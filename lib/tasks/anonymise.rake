# frozen_string_literal: true

require "db"

namespace :db do
  namespace :anonymise do
    desc "Anonymise all account and contact email addresses"
    task email: :environment do
      anonymiser = Db::AnonymiseEmail.new

      puts "Anonymising all emails for #{anonymiser.counts[:total]} users"
      puts "-------------------------"

      anonymiser.anonymise

      puts "-------------------------"
      puts "Final results"
      puts "Errors: #{anonymiser.counts[:errored]}"
      puts "Updated: #{anonymiser.counts[:processed]}"
    end
  end
end
