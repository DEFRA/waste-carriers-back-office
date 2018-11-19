# frozen_string_literal: true

class UserMigrationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize

  def new; end

  def create
    results = migrate_users
    params = { migration_results: results }
    redirect_to user_migration_results_path(params)
  end

  def results
    @migration_results = parse_results(params[:migration_results])
  end

  private

  def authorize
    authorize! :manage_back_office_users, current_user
  end

  def migrate_users
    user_migration_service = UserMigrationService.new
    user_migration_service.sync
    user_migration_service.results
  end

  def parse_results(results)
    return nil unless results.present?

    parsed_results = {}
    parsed_results[:created] = results.select { |r| r[:action] == "create" }
    parsed_results[:updated] = results.select { |r| r[:action] == "update" }
    parsed_results[:skipped] = results.select { |r| r[:action] == "skip" }
    parsed_results[:errored] = results.select { |r| r[:action] == "error" }

    parsed_results
  end
end
