# frozen_string_literal: true

require "rails_helper"

RSpec.describe "summary_stats:stats_for_date_range", type: :rake do
  include_context "rake"

  let(:start_date) { 90.days.ago.strftime('%Y-%m-%d') }
  let(:end_date) { Time.zone.today.strftime('%Y-%m-%d') }

  before { create(:registration) }

  it "runs without error" do
    expect { Rake::Task[subject].invoke(start_date, end_date) }.not_to raise_error
  end
end
