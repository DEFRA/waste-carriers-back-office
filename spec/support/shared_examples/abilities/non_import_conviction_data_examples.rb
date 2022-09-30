# frozen_string_literal: true

RSpec.shared_examples "non-import_conviction_data examples" do
  it "is not able to import conviction data" do
    is_expected.not_to be_able_to(:import_conviction_data, :all)
  end
end
