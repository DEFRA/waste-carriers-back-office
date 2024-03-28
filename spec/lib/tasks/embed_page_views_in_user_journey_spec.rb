# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:embed_page_views_in_user_journey", type: :rake do
  subject(:rake_task) { Rake::Task["one_off:embed_page_views_in_user_journey"] }

  include_context "rake"

  let(:journey_a) { create(:user_journey) }
  let(:journey_b) { create(:user_journey) }

  let(:time_a_one) { 9.days.ago.to_datetime }
  let(:time_a_two) { 8.days.ago.to_datetime }
  let(:time_b_one) { 5.days.ago.to_datetime }
  let(:time_b_two) { 4.days.ago.to_datetime }

  # Need to drop below mongoid to the ruby driver to insert directly into the page_views collection
  # because page_views are now embedded and mongoid checks for a parent user_journey:
  let(:collection) { Mongoid::Clients.default[:analytics_page_views] }

  before do
    # standalone page_views as per the previous data model
    collection.insert_one(user_journey_id: journey_a.id, time: time_a_one, route: "DIGITAL", page: "start_form")
    collection.insert_one(user_journey_id: journey_a.id, time: time_a_two, route: "DIGITAL", page: "location_form")
    collection.insert_one(user_journey_id: journey_b.id, time: time_b_one, route: "DIGITAL", page: "x_form")
    collection.insert_one(user_journey_id: journey_b.id, time: time_b_two, route: "ASSISTED_DIGITAL", page: "y_form")

    rake_task.reenable
  end

  it { expect { rake_task.invoke }.not_to raise_error }

  it "removes all documents from the page_view collection" do
    expect { rake_task.invoke }.to change(collection, :count_documents).to(0)
  end

  it "embeds the page_views in the user_journeys" do
    rake_task.invoke

    expect(journey_a.reload.page_views.count).to eq 2
    expect(journey_b.reload.page_views.count).to eq 2
  end

  it "copies the page attribute correctly" do
    rake_task.invoke

    expect(journey_a.reload.page_views.pluck(:page)).to eq %w[start_form location_form]
    expect(journey_b.reload.page_views.pluck(:page)).to eq %w[x_form y_form]
  end

  it "copies the time attribute correctly" do
    rake_task.invoke

    expect(journey_a.reload.page_views.pluck(:time).map(&:to_i)).to eq [time_a_one.to_i, time_a_two.to_i]
    expect(journey_b.reload.page_views.pluck(:time).map(&:to_i)).to eq [time_b_one.to_i, time_b_two.to_i]
  end

  it "copies the route attribute correctly" do
    rake_task.invoke

    expect(journey_a.reload.page_views.pluck(:route)).to eq %w[DIGITAL DIGITAL]
    expect(journey_b.reload.page_views.pluck(:route)).to eq %w[DIGITAL ASSISTED_DIGITAL]
  end
end
