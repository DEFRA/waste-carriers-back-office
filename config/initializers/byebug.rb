# frozen_string_literal: true

if Rails.env.development?
  require "byebug/core"
  begin
    Byebug.start_server "localhost", ENV.fetch("BYEBUG_PORT_BACK_OFFICE", 8989).to_i
  rescue Errno::EADDRINUSE
    Rails.logger.debug "Byebug server already running"
  end
end
