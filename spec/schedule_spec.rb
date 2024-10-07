# frozen_string_literal: true

require "rails_helper"
require "whenever/test"
require "open3"

# This allows us to ensure that the schedules we have declared in whenever's
# (https://github.com/javan/whenever) config/schedule.rb are valid.
# The hope is this saves us from only being able to confirm if something will
# work by actually running the deployment and seeing if it breaks (or not)
# See https://github.com/rafaelsales/whenever-test for more details

RSpec.describe "Whenever::Test::Shedule" do
  let(:schedule) { Whenever::Test::Schedule.new(file: "config/schedule.rb") }

  it "makes sure 'rake_and_format' statements exist" do
    rake_jobs = schedule.jobs[:rake_and_format]
    expect(rake_jobs.count).to eq(13)
  end

  it "picks up the EPR export run frequency and time" do
    job_details = schedule.jobs[:rake_and_format].find { |h| h[:task] == "reports:export:epr" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("21:05")
  end

  it "picks up the finance reports generation run frequency and time" do
    job_details = schedule.jobs[:rake_and_format].find { |h| h[:task] == "reports:export:generate_finance_reports" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("03:40")
  end

  it "picks up the first email reminder run frequency and time" do
    job_details = schedule.jobs[:rake_and_format].find { |h| h[:task] == "email:renew_reminder:first:send" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("02:05")
  end

  it "picks up the second email reminder run frequency and time" do
    job_details = schedule.jobs[:rake_and_format].find { |h| h[:task] == "email:renew_reminder:second:send" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("04:05")
  end

  it "picks up the Notify AD renewal letters run frequency and time" do
    job_details = schedule.jobs[:rake_and_format].find { |h| h[:task] == "notify:letters:ad_renewals" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("02:35")
  end

  it "picks up the Notify digital renewal letters run frequency and time" do
    job_details = schedule.jobs[:rake_and_format].find { |h| h[:task] == "notify:notifications:digital_renewals" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("10:00")
  end

  it "picks up the BOXI export run frequency and time" do
    job_details = schedule.jobs[:rake_and_format].find { |h| h[:task] == "reports:export:boxi" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("22:00")
  end

  it "picks up the expire registrations run frequency and time" do
    job_details = schedule.jobs[:rake_and_format].find { |h| h[:task] == "expire_registration:run" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("20:00")
  end

  it "takes the transient registration cleanup execution time from the appropriate ENV variable" do
    job_details = schedule.jobs[:rake_and_format].find { |h| h[:task] == "cleanup:transient_registrations" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("00:35")
  end

  it "takes the remove_deletable_registrations execution time from the appropriate ENV variable" do
    job_details = schedule.jobs[:rake_and_format].find { |h| h[:task] == "remove_deletable_registrations:run" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("21:00")
  end

  it "picks up the weekly export copy card orders task run frequency and time" do
    job_details = schedule.jobs[:rake_and_format].find { |h| h[:task] == "reports:export:weekly_copy_card_orders" }

    expect(job_details[:every][0]).to eq(:tuesday)
    expect(job_details[:every][1][:at]).to eq("02:15")
  end

  it "picks up the daily missing areas task run frequency and time" do
    job_details = schedule.jobs[:rake_and_format].find { |h| h[:task] == "lookups:update:missing_ea_areas" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("01:05")
  end

  it "picks up the daily missing easting/northing task run frequency and time" do
    job_details = schedule.jobs[:rake_and_format].find { |h| h[:task] == "lookups:update:missing_easting_northing" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("03:30")
  end
end
