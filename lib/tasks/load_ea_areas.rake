# frozen_string_literal: true

desc "Load EA public face area boundary definitions"
task load_ea_areas: :environment do
  results = EaPublicFaceAreaDataLoadService.run
  results.each do |result|
    unless Rails.env.test?
      puts "#{result[:action].capitalize} EA public face area \"#{result[:code]}\" (#{result[:name]})"
    end
  end
rescue StandardError => e
  puts "Error loading EA public face areas: #{e}\n#{e.backtrace}"
end
