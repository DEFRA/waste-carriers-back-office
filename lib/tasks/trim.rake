namespace :db do
  namespace :sessions do
    desc "Trim old sessions from the database (older than 30 days)"
    task :trim => :environment do
      cutoff_period = 30.days.ago

      # Assuming that the session data is stored in a Mongoid document named 'Session'
      MongoidStore::Session.where(:updated_at.lt => cutoff_period).delete_all

      puts "Sessions older than #{cutoff_period} have been removed."
    end
  end
end

