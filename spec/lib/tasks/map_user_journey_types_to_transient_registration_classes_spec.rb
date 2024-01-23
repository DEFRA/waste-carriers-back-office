# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:map_user_journey_types_to_transient_registration_classes", type: :rake do
  subject(:rake_task) { Rake::Task["one_off:map_user_journey_types_to_transient_registration_classes"] }

  include_context "rake"

  before do
    create_list(:user_journey, 2, journey_type: "registration")
    create_list(:user_journey, 3, journey_type: "renewal")

    rake_task.reenable
  end

  it { expect { rake_task.invoke }.not_to raise_error }

  it { expect { rake_task.invoke }.to change { WasteCarriersEngine::Analytics::UserJourney.where(journey_type: "registration").count }.to(0) }

  it { expect { rake_task.invoke }.to change { WasteCarriersEngine::Analytics::UserJourney.where(journey_type: "NewRegistration").count }.to(2) }

  it { expect { rake_task.invoke }.to change { WasteCarriersEngine::Analytics::UserJourney.where(journey_type: "renewal").count }.to(0) }

  it { expect { rake_task.invoke }.to change { WasteCarriersEngine::Analytics::UserJourney.where(journey_type: "RenewingRegistration").count }.to(3) }
end
