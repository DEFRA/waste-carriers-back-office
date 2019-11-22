# frozen_string_literal: true

RSpec.shared_examples "agency_super examples" do
  it "should be able to manage back office users" do
    should be_able_to(:manage_back_office_users, User.new)
  end

  it "should be able to create an agency user" do
    should be_able_to(:create_agency_user, User.new)
  end
end
