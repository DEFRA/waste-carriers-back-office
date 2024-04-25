# frozen_string_literal: true

namespace :one_off do
  desc "Fix missing conviction signoffs"
  task fix_missing_conviction_signoffs: :environment do

    registrations = WasteCarriersEngine::Registration.where(
      :conviction_sign_offs.in => [nil, []],
      "key_people.conviction_search_result.match_result": "YES",
      "metaData.last_modified": { "$gte": DateTime.parse("2024-03-01") }
    )

    puts "Updating #{registrations.count} registration(s)" unless Rails.env.test?
    count = 0
    registrations.each do |registration|

      registration.conviction_sign_offs << WasteCarriersEngine::ConvictionSignOff.new(confirmed: "no")

      count += 1
      puts "#{count}. Added conviction_sign_off to registration #{registration.regIdentifier}" unless Rails.env.test?
    end
  end
end
