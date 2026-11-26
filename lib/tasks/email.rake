# frozen_string_literal: true

namespace :email do
  namespace :renew_reminder do
    namespace :first do
      desc "Send first email reminder to all registrations expiring in X days (default is 28)"
      task send: :environment do
        next unless WasteCarriersEngine::FeatureToggle.active?(:renewal_reminders)
        next if WasteCarriersEngine::FeatureToggle.active?(:service_closure)

        registrations_count = FirstRenewalReminderService.run
        StdoutLogger.log "Sent #{registrations_count} first renewal reminder(s)"
      end
    end

    namespace :second do
      desc "Send second email reminder to all registrations expiring in X days (default is 14)"
      task send: :environment do
        next unless WasteCarriersEngine::FeatureToggle.active?(:renewal_reminders)
        next if WasteCarriersEngine::FeatureToggle.active?(:service_closure)

        registrations_count = SecondRenewalReminderService.run
        StdoutLogger.log "Sent #{registrations_count} second renewal reminder(s)"
      end
    end
  end
end
