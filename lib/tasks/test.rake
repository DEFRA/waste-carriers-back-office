# frozen_string_literal: true

namespace :test do
  desc "Test rake task: one"
  task one: :environment do
    puts "First line"
    puts "Second line"
  end

  desc "Test rake task: two"
  task two: :environment do
    puts "First line"
    puts "Second line"
  end
end
