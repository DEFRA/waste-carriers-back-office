# frozen_string_literal: true

require "rails_helper"

RSpec.describe EditFormPresenter do
  subject(:presenter) { described_class.new(form, view) }

  let(:form) { instance_double(EditForm, transient_registration: transient_registration) }

  describe "#receipt_email" do
    context "when the field does not exist" do
      let(:transient_registration) { instance_double(EditRegistration) }

      it "returns nothing" do
        allow(transient_registration).to receive(:receipt_email)

        expect(presenter.receipt_email).to be_nil
      end
    end

    context "when the field exists" do
      let(:transient_registration) { instance_double(EditRegistration, receipt_email: receipt_email) }
      let(:receipt_email) { "whatever@example.com" }

      it "returns the value in receipt email" do
        expect(presenter.receipt_email).to eq(receipt_email)
      end
    end
  end
end
