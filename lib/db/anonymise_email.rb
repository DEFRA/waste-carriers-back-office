# frozen_string_literal: true

require "db/db"

module Db
  class AnonymiseEmail

    attr_reader :counts

    def initialize
      @collections = {
        registrations: Db.registrations_collection,
        renewals: Db.transient_registrations_collection,
        users: Db.users_collection
      }

      @counts = Db.counts(@collections[:users])
      @counts[:id_increment] = 1

      @counts[:users_updated] = 0
      @counts[:registrations_updated] = 0
      @counts[:transient_registrations_updated] = 0

      @paging = Db.paging(@counts[:total], 100)
    end

    def anonymise(debug = false)
      while @paging[:page_number] <= @paging[:num_of_pages]
        anonymise_users
        @paging[:page_number] += 1
        print_progress unless debug
      end
    end

    private

    def anonymise_users
      Db.paged_users(@paging).each do |user|
        unless user["email"].end_with?("@example.com")
          result = anonymise_email(
            debug,
            user["email"],
            "user#{@counts[:id_increment]}@example.com"
          )
        end
        update_counts(result)
      end
    end

    def update_counts(result)
      @counts[:id_increment] += 1

      case result
      when true
        @counts[:processed] += 1
      when false
        @counts[:errored] += 1
      else
        @counts[:skipped] += 1
      end
    end

    def anonymise_email(debug, old_email, new_email)
      results = update_documents(old_email, new_email)

      STDOUT.sync = true
      puts "#{old_email} => #{new_email}: #{results[:regs]}, #{results[:renewals]}" if debug

      true
    rescue StandardError => e
      puts "Error with #{old_email}: #{e.message}"
      false
    end

    def update_documents(old_email, new_email)
      results = {
        regs: update_registrations(old_email, new_email),
        renewals: update_transient_registrations(old_email, new_email),
        user: update_user(old_email, new_email)
      }
      raise "Failed to update" unless results[:user].positive?

      results
    end

    def update_registrations(old_email, new_email)
      result = @collections[:registrations]
               .find(accountEmail: old_email)
               .update_many("$set": { accountEmail: new_email, contactEmail: new_email })
      result.modified_count
    end

    def update_transient_registrations(old_email, new_email)
      return 0 unless @collections[:renewals]

      result = @collections[:renewals]
               .find(accountEmail: old_email)
               .update_many("$set": { accountEmail: new_email, contactEmail: new_email })
      result.modified_count
    end

    def update_user(old_email, new_email)
      result = @collections[:users]
               .find(email: old_email)
               .update_one("$set": { email: new_email })
      result.n
    end

    def print_progress
      STDOUT.sync = true
      print "."
    end
  end
end
