# frozen_string_literal: true

require "db"

namespace :db do
  namespace :anonymise do
    desc "Anonymise all account and contact email addresses"
    task email: :environment do
      anonymiser = Db::AnonymiseEmail.new
      anonymiser.anonymise
    end
  end
end
