# frozen_string_literal: true

class TestMailer < ActionMailer::Base
  def test_email
    from_address = "#{Rails.configuration.email_service_name} <#{Rails.configuration.email_service_email}>"
    subject = "Waste Carriers Test email"
    mail(to: Rails.configuration.email_test_address,
         subject: subject,
         from: from_address) do |format|
      format.text(content_type: "text/plain", charset: "UTF-8", content_transfer_encoding: "7bit")
    end
  end
end
