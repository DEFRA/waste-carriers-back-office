# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:remove_obsolete_storm_user_fields", type: :task do
  let(:task) { Rake::Task["one_off:remove_obsolete_storm_user_fields"] }
  let(:user) { create(:user) }

  include_context "rake"

  before do
    task.reenable
  end

  it "runs without error" do
    expect { task.invoke }.not_to raise_error
  end

  context "when a user has the obsolete Storm fields" do
    before do
      User.collection.update_one(
        { _id: user.id },
        { "$set": { storm_user_id: "12345", call_recording_state: false } }
      )
    end

    it "removes the storm_user_id field" do
      task.invoke

      expect(User.collection.find({ _id: user.id, storm_user_id: { "$exists": true } }).count).to be_zero
    end

    it "removes the call_recording_state field" do
      task.invoke

      expect(User.collection.find({ _id: user.id, call_recording_state: { "$exists": true } }).count).to be_zero
    end
  end
end
