# frozen_string_literal: true

require "rails_helper"

RSpec.describe "summary_stats:stats_for_date_range", type: :task do
  include_context "rake"

  original_stdout = $stdout

  let(:start_date) { 90.days.ago.strftime("%Y-%m-%d") }
  let(:end_date) { Time.zone.today.strftime("%Y-%m-%d") }

  # rubocop:disable RSpec/ExpectOutput
  before do
    # suppress noisy outputs during unit test
    $stdout = StringIO.new

    create(:registration)
  end

  after do
    $stdout = original_stdout
  end
  # rubocop:enable RSpec/ExpectOutput

  it "runs without error" do
    expect { Rake::Task[subject].invoke(start_date, end_date) }.not_to raise_error
  end
end
