# frozen_string_literal: true

RSpec.shared_examples "non-developer examples" do
  it "is not able to toggle features" do
    is_expected.not_to be_able_to(:manage, WasteCarriersEngine::FeatureToggle)
  end
end
