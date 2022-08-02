# config/initializers/byebug.rb
# frozen_string_literal: true

if Rails.env.development?
  require "byebug/core"
  begin
    # Byebug.wait_connection = true
    Byebug.start_server "localhost", 8989
  rescue Errno::EADDRINUSE
    Rails.logger.debug "Byebug server already running"
  end
end
