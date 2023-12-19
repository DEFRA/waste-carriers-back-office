# frozen_string_literal: true

RSpec.shared_examples "user is not logged in" do |action:, path:|
  subject(:call_route) { send(action, send(path, "foo")) }

  before do
    user = create(:user)
    sign_out(user)
  end

  it "returns a 302 response" do
    call_route

    expect(response).to have_http_status(:found)
  end

  it "redirects to the login page" do
    call_route

    expect(response).to redirect_to(new_user_session_path)
  end

  it "does not create a new transient registration" do
    expect { call_route }.not_to change(WasteCarriersEngine::TransientRegistration, :count)
  end
end
