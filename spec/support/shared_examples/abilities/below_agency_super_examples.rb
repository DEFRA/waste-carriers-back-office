# frozen_string_literal: true

RSpec.shared_examples "below agency_super examples" do
  it "should not be able to manage back office users" do
    should_not be_able_to(:manage_back_office_users, user)
  end

  it "should not be able to create an agency user" do
    should_not be_able_to(:create_agency_user, user)
  end
end
