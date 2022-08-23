# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:rename_import_conviction_data_role", type: :rake do
  include_context "rake"

  it "runs without error" do
    expect { subject.invoke }.not_to raise_error
  end
end
