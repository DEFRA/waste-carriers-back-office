# frozen_string_literal: true

RSpec.shared_examples "import_conviction_data examples" do
  it "is able to import conviction data" do
    expect(subject).to be_able_to(:import_conviction_data, :all)
  end
end
