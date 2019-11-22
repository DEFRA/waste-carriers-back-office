# frozen_string_literal: true

RSpec.shared_examples "finance_super examples" do
  it "should be able to manage back office users" do
    should be_able_to(:manage_back_office_users, user)
  end

  it "should be able to create an agency user" do
    should be_able_to(:create_agency_user, user)
  end

  it "should be able to create an agency_with_refund user" do
    should be_able_to(:create_agency_with_refund_user, user)
  end

  it "should be able to create a finance user" do
    should be_able_to(:create_finance_user, user)
  end

  it "should be able to create a finance admin user" do
    should be_able_to(:create_finance_admin_user, user)
  end
end
