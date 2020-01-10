# frozen_string_literal: true

RSpec.shared_examples "agency_super examples" do
  it "should be able to manage back office users" do
    should be_able_to(:manage_back_office_users, User)
  end

  it "should be able to manage agency users" do
    should be_able_to(:manage_agency_users, User)
  end

  it "should be able to cease a registration" do
    should be_able_to(:cease, WasteCarriersEngine::Registration)
  end

  it "should be able to revoke a registration" do
    should be_able_to(:revoke, WasteCarriersEngine::Registration)
  end
end
