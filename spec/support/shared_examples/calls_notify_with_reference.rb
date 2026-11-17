# frozen_string_literal: true

RSpec.shared_examples "calls notify with reference" do

  let(:client) { instance_double(Notifications::Client, send_email: nil, send_sms: nil, send_letter: nil) }

  before do
    allow(Notifications::Client).to receive(:new).and_return(client)
    run_service
  end

  it { expect(client).to have_received(send_action).with(hash_including(reference:)) }

end
