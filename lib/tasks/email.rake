# frozen_string_literal: true

namespace :email do
  desc "Send a test email to confirm confirm setup is correct"
  task test: :environment do
    puts TestMailer.test_email.deliver_now
  end
end
