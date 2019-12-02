# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Reports task", type: :rake do
  include_context "rake"

  describe "reports:export:epr" do
    it "runs without error" do
      expect { subject.invoke }.not_to raise_error
    end
  end
end
