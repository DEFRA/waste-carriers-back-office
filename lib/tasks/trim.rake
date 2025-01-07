# frozen_string_literal: true

namespace :db do
  namespace :sessions do
    desc "Trim old sessions from the database (older than 30 days)"
    task trim: :environment do
      cutoff_time = 30.days.ago

      # Assuming that the session data is stored in a Mongoid document named 'Session'
      old_sessions = MongoidStore::Session.where(:updated_at.lt => cutoff_time)
      old_sessions_count = old_sessions.size
      old_sessions.delete_all

      puts "#{old_sessions_count} session(s) older than #{cutoff_time} have been removed." unless Rails.env.test?
    end
  end
end
