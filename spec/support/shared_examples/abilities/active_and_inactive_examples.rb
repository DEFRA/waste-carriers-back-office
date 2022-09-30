# frozen_string_literal: true

RSpec.shared_examples "active and inactive examples" do
  context "when the user is active" do
    let(:deactivated) { false }

    it "is able to use the back office" do
      should be_able_to(:use_back_office, :all)
    end
  end

  context "when the user is deactivated" do
    let(:deactivated) { true }

    it "is not able to use the back office" do
      should_not be_able_to(:use_back_office, :all)
    end
  end
end
