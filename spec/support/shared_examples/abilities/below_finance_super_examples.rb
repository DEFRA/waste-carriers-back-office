# frozen_string_literal: true

RSpec.shared_examples "below finance_super examples" do
  it "should not be able to manage back office users" do
    should_not be_able_to(:manage_back_office_users, user)
  end

  it "should not be able to create an agency user" do
    should_not be_able_to(:create_agency_user, user)
  end

  it "should not be able to create an agency_with_refund user" do
    should_not be_able_to(:create_agency_with_refund_user, user)
  end

  it "should not be able to create a finance user" do
    should_not be_able_to(:create_finance_user, user)
  end

  it "should not be able to create a finance admin user" do
    should_not be_able_to(:create_finance_admin_user, user)
  end
end
