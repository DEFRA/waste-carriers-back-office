# frozen_string_literal: true

RSpec.shared_examples "non-developer examples" do
  it "should not be able to toggle features" do
    should_not be_able_to(:manage, WasteCarriersEngine::FeatureToggle)
  end
end
