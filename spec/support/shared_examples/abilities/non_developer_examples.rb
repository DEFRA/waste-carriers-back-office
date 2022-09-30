# frozen_string_literal: true

RSpec.shared_examples "non-developer examples" do
  it "is not able to toggle features" do
    should_not be_able_to(:manage, WasteCarriersEngine::FeatureToggle)
  end
end
