# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:clear_area_not_found_values", type: :rake do
  subject(:rake_task) { Rake::Task["one_off:clear_area_not_found_values"] }

  include_context "rake"

  let(:registration_with_area) { create(:registration) }
  let(:registration_first_area_not_found) { create(:registration) }
  let(:registration_last_area_not_found) { create(:registration) }

  before do
    registration_with_area.addresses.first.update(area: "Foo")
    registration_first_area_not_found.addresses.first.update(area: "Not found")
    registration_last_area_not_found.addresses.first.update(area: "Bar")
    registration_last_area_not_found.addresses.last.update(area: "Not found")

    rake_task.reenable
  end

  it { expect { rake_task.invoke }.not_to raise_error }

  it { expect { rake_task.invoke }.not_to change { registration_with_area.reload.addresses.first } }

  it { expect { rake_task.invoke }.to change { registration_first_area_not_found.reload.addresses.first.area }.to nil }

  it { expect { rake_task.invoke }.not_to change { registration_last_area_not_found.reload.addresses.first.area } }

  it { expect { rake_task.invoke }.to change { registration_last_area_not_found.reload.addresses.last.area }.to nil }
end
