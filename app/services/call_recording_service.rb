# frozen_string_literal: true

class CallRecordingService
  SUCCESS_RESULT = "0"
  attr_reader :user

  def initialize(user:)
    @user = user
  end

  def pause
    response = DefraRuby::Storm::PauseCallRecordingService.run(agent_user_id: get_agent_user_id(user))

    return true if response.result == SUCCESS_RESULT

    false
  rescue DefraRuby::Storm::ApiError => e
    Rails.logger.error "Error pausing call recording: #{e.message}"
    false
  end

  def resume
    response = DefraRuby::Storm::ResumeCallRecordingService.run(agent_user_id: get_agent_user_id(user))

    return true if response.result == SUCCESS_RESULT

    false
  rescue DefraRuby::Storm::ApiError => e
    Rails.logger.error "Error resuming call recording: #{e.message}"
    false
  end

  private

  def get_agent_user_id(user)
    return user.storm_user_id unless user.storm_user_id.nil?
    return get_agent_user_id_from_email(user) unless user.email.nil?

    nil
  end

  def get_agent_user_id_from_email(user)
    mappings = YAML.load_file(Rails.root.join("config/storm_email_to_username_mappings.yml")) || {}
    username = mappings[user.email] || user.email
    agency_user_id = DefraRuby::Storm::UserDetailsService.run(username: username)&.user_id
    user.update(storm_user_id: agency_user_id) unless agency_user_id.nil?
    agency_user_id
  rescue DefraRuby::Storm::ApiError => e
    Rails.logger.error "Error getting agent user id from email: #{e.class} #{e.message}"
    raise e
  end
end
