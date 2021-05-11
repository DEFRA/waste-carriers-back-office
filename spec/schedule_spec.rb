# frozen_string_literal: true

require "rails_helper"
require "whenever/test"
require "open3"

# This allows us to ensure that the schedules we have declared in whenever's
# (https://github.com/javan/whenever) config/schedule.rb are valid.
# The hope is this saves us from only being able to confirm if something will
# work by actually running the deployment and seeing if it breaks (or not)
# See https://github.com/rafaelsales/whenever-test for more details

RSpec.describe "Whenever schedule" do
  let(:schedule) { Whenever::Test::Schedule.new(file: "config/schedule.rb") }

  it "makes sure 'rake' statements exist" do
    rake_jobs = schedule.jobs[:rake]
    expect(rake_jobs.count).to eq(8)
  end

  it "picks up the EPR export run frequency and time" do
    job_details = schedule.jobs[:rake].find { |h| h[:task] == "reports:export:epr" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("21:05")
  end

  it "picks up the first email reminder run frequency and time" do
    job_details = schedule.jobs[:rake].find { |h| h[:task] == "email:renew_reminder:first:send" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("02:05")
  end

  it "picks up the second email reminder run frequency and time" do
    job_details = schedule.jobs[:rake].find { |h| h[:task] == "email:renew_reminder:second:send" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("04:05")
  end

  it "picks up the Notify AD renewal letters run frequency and time" do
    job_details = schedule.jobs[:rake].find { |h| h[:task] == "notify:letters:ad_renewals" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("02:35")
  end

  it "picks up the Notify digital renewal letters run frequency and time" do
    job_details = schedule.jobs[:rake].find { |h| h[:task] == "notify:letters:digital_renewals" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("02:45")
  end

  it "picks up the BOXI export run frequency and time" do
    job_details = schedule.jobs[:rake].find { |h| h[:task] == "reports:export:boxi" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("22:00")
  end

  it "picks up the expire registrations run frequency and time" do
    job_details = schedule.jobs[:rake].find { |h| h[:task] == "expire_registration:run" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("20:00")
  end

  it "takes the transient registration cleanup execution time from the appropriate ENV variable" do
    job_details = schedule.jobs[:rake].find { |h| h[:task] == "cleanup:transient_registrations" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("00:35")
  end
end
