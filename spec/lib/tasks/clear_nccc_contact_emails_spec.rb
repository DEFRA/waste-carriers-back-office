# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:clear_nccc_contact_emails", type: :rake do
  include_context "rake"

  it "runs without error" do
    expect(ClearNcccContactEmailsService).to receive(:run)
    expect { subject.invoke }.not_to raise_error
  end
end
