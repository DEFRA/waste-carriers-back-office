# frozen_string_literal: true

RSpec.shared_examples "non-import_conviction_data examples" do
  it "should not be able to import conviction data" do
    should_not be_able_to(:import_conviction_data, :all)
  end
end
