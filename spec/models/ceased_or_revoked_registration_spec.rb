# frozen_string_literal: true

require "rails_helper"

RSpec.describe CeasedOrRevokedRegistration do
  subject(:ceased_or_revoked_registration) { build(:ceased_or_revoked_registration) }

  context "with default status" do
    context "when a CeasedOrRevokedRegistration is created" do
      it "has the state of :cease_or_revoke_form" do
        expect(ceased_or_revoked_registration).to have_state(:cease_or_revoke_form)
      end
    end
  end

  context "with validations" do
    describe "reg_identifier" do
      context "when a CeasedOrRevokedRegistration is created" do
        it "is not valid if the reg_identifier is in the wrong format" do
          ceased_or_revoked_registration.reg_identifier = "foo"

          expect(ceased_or_revoked_registration).not_to be_valid
        end

        it "is not valid if no matching registration exists" do
          ceased_or_revoked_registration.reg_identifier = "CBDU999999"

          expect(ceased_or_revoked_registration).not_to be_valid
        end
      end
    end
  end
end
