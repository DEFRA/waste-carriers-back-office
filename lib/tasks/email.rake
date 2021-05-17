# frozen_string_literal: true

namespace :email do
  namespace :renew_reminder do
    namespace :first do
      desc "Send first email reminder to all registrations expiring in X days (default is 28)"
      task send: :environment do
        return unless WasteCarriersEngine::FeatureToggle.active?(:renewal_reminders)

        FirstRenewalReminderService.run
      end
    end

    namespace :second do
      desc "Send second email reminder to all registrations expiring in X days (default is 14)"
      task send: :environment do
        return unless WasteCarriersEngine::FeatureToggle.active?(:renewal_reminders)

        SecondRenewalReminderService.run
      end
    end
  end
end
