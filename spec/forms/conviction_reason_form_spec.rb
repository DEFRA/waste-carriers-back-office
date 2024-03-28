# frozen_string_literal: true

require "rails_helper"

RSpec.describe ConvictionReasonForm, type: :model do
  describe "#submit" do
    context "when the form is valid" do
      let(:conviction_reason_form) { build(:conviction_reason_form) }
      let(:valid_params) do
        {
          revoked_reason: conviction_reason_form.revoked_reason
        }
      end
      let(:renewing_registration) { build(:renewing_registration) }

      it "submits" do
        expect(conviction_reason_form.submit(valid_params)).to be(true)
      end

      context "when the convictions have already been approved" do
        before do
          allow(WasteCarriersEngine::RenewingRegistration).to receive(:new).and_return(renewing_registration)
          allow(renewing_registration).to receive(:conviction_check_approved?).and_return(true)
        end

        it "does not submit" do
          expect(conviction_reason_form.submit(valid_params)).to be(false)
        end
      end

      context "when the convictions have already been rejected" do
        let(:meta_data) { build(:metaData) }

        before do
          allow(WasteCarriersEngine::MetaData).to receive(:new).and_return(meta_data)
          allow(meta_data).to receive(:REVOKED?).and_return(true)
        end

        it "does not submit" do
          expect(conviction_reason_form.submit(valid_params)).to be(false)
        end
      end
    end

    context "when the form is not valid" do
      let(:conviction_reason_form) { build(:conviction_reason_form) }
      let(:invalid_params) do
        {
          revoked_reason: nil
        }
      end

      it "does not submit" do
        expect(conviction_reason_form.submit(invalid_params)).to be(false)
      end
    end
  end
end
