# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:clear_duplicate_page_views", type: :rake do
  subject(:rake_task) { Rake::Task["one_off:clear_duplicate_page_views"] }

  include_context "rake"

  let!(:user_journey_without_duplicates) do
    create(:user_journey, visited_pages: %w[start_form location_form business_type_form])
  end

  let!(:user_journey_with_duplicates) do
    create(:user_journey, visited_pages: %w[start_form location_form location_form business_type_form])
  end

  let!(:user_journey_with_triplicates) do
    create(:user_journey, visited_pages: %w[start_form location_form business_type_form business_type_form business_type_form])
  end

  before { rake_task.reenable }

  it { expect { rake_task.invoke }.not_to raise_error }

  it { expect { rake_task.invoke }.not_to change { user_journey_without_duplicates.reload.page_views.count } }

  it { expect { rake_task.invoke }.to change { user_journey_with_duplicates.reload.page_views.count }.to 3 }

  it { expect { rake_task.invoke }.to change { user_journey_with_triplicates.reload.page_views.count }.to 3 }
end
