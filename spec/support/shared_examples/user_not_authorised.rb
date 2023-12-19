# frozen_string_literal: true

RSpec.shared_examples "user is not authorised to perform action" do |action:, path:, role:|
  let(:user) { create(:user, role:) }
  let(:transient_registration) { create(:new_registration) }

  before { sign_in(user) }

  it "redirects to the permissions error page" do
    send(action, send(path, transient_registration.token))

    expect(response).to redirect_to("/bo/pages/permission")
  end
end
