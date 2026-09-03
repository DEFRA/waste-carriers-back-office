# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:clear_zero_easting_northings", type: :task do
  subject(:rake_task) { Rake::Task["one_off:clear_zero_easting_northings"] }

  include_context "rake"

  let(:registration_with_coordinates) { create(:registration) }
  let(:registration_with_zeroes) { create(:registration) }
  let(:registration_without_coordinates) { create(:registration) }

  before do
    registration_with_coordinates.addresses.first.update(easting: 358_205.03, northing: 172_708.07)
    registration_with_zeroes.addresses.first.update(easting: 0.0, northing: 0.0)
    registration_without_coordinates.addresses.first.update(easting: nil, northing: nil)

    rake_task.reenable
  end

  it { expect { rake_task.invoke }.not_to raise_error }

  it "clears the zeroed easting" do
    expect { rake_task.invoke }.to change { registration_with_zeroes.reload.addresses.first.easting }.to nil
  end

  it "clears the zeroed northing" do
    expect { rake_task.invoke }.to change { registration_with_zeroes.reload.addresses.first.northing }.to nil
  end

  it "leaves valid coordinates alone" do
    expect { rake_task.invoke }.not_to change { registration_with_coordinates.reload.addresses.first.easting }
  end

  it "leaves addresses without coordinates alone" do
    expect { rake_task.invoke }.not_to change { registration_without_coordinates.reload.addresses.first.easting }
  end
end
