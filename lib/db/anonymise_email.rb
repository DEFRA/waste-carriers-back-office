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

      @paging = Db.paging(@counts[:total], 100)
    end

    def anonymise
      while @paging[:page_number] <= @paging[:num_of_pages]
        page_through_users
        @paging[:page_number] += 1
        print_progress
      end
    end

    private

    def page_through_users
      registration_updates = []
      renewal_updates = []
      user_updates = []

      Db.paged_users(@paging).each do |user|
        next if user["email"].end_with?("@example.com")

        operations = generate_operations(
          user["email"],
          "user#{@counts[:id_increment]}@example.com"
        )

        registration_updates << operations[:registration]
        renewal_updates << operations[:transient_registration]
        user_updates << operations[:user]

        @counts[:id_increment] += 1
      end
      apply_operations(
        registration_updates,
        renewal_updates,
        user_updates
      )
    end

    def apply_operations(registration_updates, renewal_updates, user_updates)
      @collections[:users].bulk_write(user_updates) unless user_updates.empty?
      @collections[:registrations].bulk_write(registration_updates) unless registration_updates.empty?

      return unless @collections[:renewals]

      @collections[:renewals].bulk_write(renewal_updates) unless renewal_updates.empty?
    rescue StandardError => e
      puts e.message
    end

    def generate_operations(old_email, new_email)
      {
        registration: update_registrations(old_email, new_email),
        transient_registration: update_registrations(old_email, new_email),
        user: update_user(old_email, new_email)
      }
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
      {
        update_many: {
          filter: { accountEmail: old_email },
          update: { "$set": { accountEmail: new_email, contactEmail: new_email } }
        }
      }
    end

    def update_user(old_email, new_email)
      {
        update_many: {
          filter: { email: old_email },
          update: { "$set": { email: new_email } }
        }
      }
    end

    def print_progress
      STDOUT.sync = true
      print "."
    end
  end
end
