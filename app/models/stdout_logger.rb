# frozen_string_literal: true

class StdoutLogger
  def self.log(msg)
    # Avoid cluttering up the test logs
    puts msg unless Rails.env.test? # rubocop:disable Rails/Output
  end
end
