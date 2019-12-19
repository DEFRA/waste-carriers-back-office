# frozen_string_literal: true

RSpec.shared_examples "active and inactive examples" do
  context "when the user is active" do
    let(:active) { true }

    it "should be able to use the back office" do
      should be_able_to(:use_back_office, :all)
    end
  end

  context "when the user is inactive" do
    let(:active) { false }

    it "should not be able to use the back office" do
      should_not be_able_to(:use_back_office, :all)
    end
  end
end
