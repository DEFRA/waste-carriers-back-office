# frozen_string_literal: true

require "db/db"

module Db
  class AnonymiseEmail

    attr_reader :counts

    def initialize
      @counts = Db.counts(Db.users_collection)
      @counts[:id_increment] = 1

      @paging = Db.paging(@counts[:total], 100)
    end

    def anonymise
      while @paging[:page_number] <= @paging[:num_of_pages]
        Db.paged_users(@paging).each do |user|
          result = anonymise_email(
            user["email"],
            "user#{@counts[:id_increment]}@example.com"
          )
          update_counts(result)
        end
        @paging[:page_number] += 1
      end
    end

    private

    def update_counts(result)
      @counts[:id_increment] += 1
      @counts[:processed] += 1 if result
      @counts[:errored] += 1 unless result
    end

    def anonymise_email(old_email, new_email)
      regs = update_registrations(old_email, new_email)
      renewals = update_transient_registrations(old_email, new_email)
      user = update_user(old_email, new_email)

      raise "Failed to update" unless user.positive?

      puts "#{old_email} => #{new_email}: #{regs}, #{renewals}"

      true
    rescue StandardError => e
      puts "Error with #{old_email}: #{e.message}"
      false
    end

    def update_registrations(old_email, new_email)
      result = Db.registrations_collection
                 .find(accountEmail: old_email)
                 .update_many("$set": { accountEmail: new_email, contactEmail: new_email })
      result.modified_count
    end

    def update_transient_registrations(old_email, new_email)
      result = Db.transient_registrations_collection
                 .find(accountEmail: old_email)
                 .update_many("$set": { accountEmail: new_email, contactEmail: new_email })
      result.modified_count
    end

    def update_user(old_email, new_email)
      result = Db.users_collection
                 .find(email: old_email)
                 .update_one("$set": { email: new_email })
      result.n
    end
  end
end
