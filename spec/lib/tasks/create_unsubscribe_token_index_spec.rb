# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:create_unsubscribe_token_index", type: :rake do
  include_context "rake"

  it "runs without error" do
    expect { subject.invoke }.not_to raise_error
  end
end
