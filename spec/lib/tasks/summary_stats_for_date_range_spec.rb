# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/ExpectOutput
RSpec.describe "summary_stats:stats_for_date_range", type: :rake do
  include_context "rake"

  original_stdout = $stdout

  let(:start_date) { 90.days.ago.strftime("%Y-%m-%d") }
  let(:end_date) { Time.zone.today.strftime("%Y-%m-%d") }

  before do
    # suppress noisy outputs during unit test
    $stdout = StringIO.new

    create(:registration)
  end

  after do
    $stdout = original_stdout
  end

  it "runs without error" do
    expect { Rake::Task[subject].invoke(start_date, end_date) }.not_to raise_error
  end
end
# rubocop:enable RSpec/ExpectOutput
