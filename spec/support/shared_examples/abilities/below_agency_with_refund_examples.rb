# frozen_string_literal: true

RSpec.shared_examples "below agency_with_refund examples" do
  it "should not be able to view revoked reasons" do
    should_not be_able_to(:view_revoked_reasons, transient_registration)
  end
end
