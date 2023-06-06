# frozen_string_literal: true

require "rails_helper"
require "rake"

RSpec.describe "db:sessions:trim" do
  it "removes sessions older than 30 days" do
    # Create test sessions
    newer_session = MongoidStore::Session.create!(updated_at: 1.day.ago)
    older_session = MongoidStore::Session.create!(updated_at: 31.days.ago)

    # Run the rake task
    Rake::Task["db:sessions:trim"].invoke

    # The newer_session should still exist
    expect(MongoidStore::Session.find_by(id: newer_session.id)).to be_present

    # The older_session should have been deleted
    expect do
      MongoidStore::Session.find(older_session.id)
    end.to raise_error(Mongoid::Errors::DocumentNotFound)
  end
end
