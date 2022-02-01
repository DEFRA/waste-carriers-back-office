# frozen_string_literal: true

RSpec.shared_examples "import_conviction_data examples" do
  it "should be able to import conviction data" do
    should be_able_to(:import_conviction_data, :all)
  end
end
