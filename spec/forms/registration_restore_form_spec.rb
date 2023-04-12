# frozen_string_literal: true

require "rails_helper"

RSpec.describe RegistrationRestoreForm do
  let(:registration_restore_form) { build(:registration_restore_form) }

  describe "#submit" do
    context "when parameters are valid" do
      let(:params) { { registration_restore_form: { restored_reason: "foo" } } }

      it "returns true" do
        expect(registration_restore_form.submit(params)).to be_truthy
      end
    end

    context "when parameters are empty" do
      it "returns false" do
        expect(registration_restore_form.submit({})).to be_falsey
      end
    end
  end
end
