# frozen_string_literal: true

require "rails_helper"

RSpec.describe Reports::UserExportSerializer do
  let(:active_user) do
    create(
      :user,
      active: true,
      current_sign_in_at: Time.at(0).utc,
      invitation_accepted_at: Time.at(0).utc
    )
  end

  let(:invited_user) do
    create(
      :user,
      active: false,
      invitation_sent_at: Time.at(0).utc,
      invitation_accepted_at: Time.at(0).utc
    )
  end

  let(:inactive_user) do
    create(:user, active: false)
  end

  describe "#to_csv" do
    subject { described_class.new.to_csv }

    let(:expected_columns) do
      [
        "Email Address",
        "Status",
        "Last Logged In",
        "Invitation Accepted"
      ]
    end

    before do
      active_user
      inactive_user
      invited_user
    end

    it "includes the expected header" do
      expect(subject).to include(expected_columns.map { |title| "\"#{title}\"" }.join(","))
    end

    it "includes the correct number of rows" do
      expect(subject.split("\n").length).to eq(User.count + 1)
    end

    it "correctly includes active users" do
      expect(subject.scan(active_user.email).size).to eq(1)

      CSV.parse(subject).detect { |row| row.first == active_user.email }.tap do |row|
        expect(row[0]).to eq(active_user.email)
        expect(row[1]).to eq("Active")
        expect(row[2]).to eq("01/01/1970 00:00")
        expect(row[3]).to eq("01/01/1970 00:00")
      end
    end

    it "correctly includes inactive users" do
      expect(subject.scan(inactive_user.email).size).to eq(1)

      CSV.parse(subject).detect { |row| row.first == inactive_user.email }.tap do |row|
        expect(row[0]).to eq(inactive_user.email)
        expect(row[1]).to eq("Deactivated")
        expect(row[2]).to eq("")
        expect(row[3]).to eq("")
      end
    end

    it "correctly includes inactive users with a sent invitation" do
      expect(subject.scan(invited_user.email).size).to eq(1)

      CSV.parse(subject).detect { |row| row.first == invited_user.email }.tap do |row|
        expect(row[0]).to eq(invited_user.email)
        expect(row[1]).to eq("Invitation Sent")
        expect(row[2]).to eq("")
        expect(row[3]).to eq("01/01/1970 00:00")
      end
    end
  end
end
