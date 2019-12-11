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

      it "should submit" do
        expect(conviction_reason_form.submit(valid_params)).to eq(true)
      end

      context "when the convictions have already been approved" do
        before do
          allow_any_instance_of(WasteCarriersEngine::RenewingRegistration).to receive(:conviction_check_approved?).and_return(true)
        end

        it "should not submit" do
          expect(conviction_reason_form.submit(valid_params)).to eq(false)
        end
      end

      context "when the convictions have already been rejected" do
        before do
          allow_any_instance_of(WasteCarriersEngine::MetaData).to receive(:REVOKED?).and_return(true)
        end

        it "should not submit" do
          expect(conviction_reason_form.submit(valid_params)).to eq(false)
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

      it "should not submit" do
        expect(conviction_reason_form.submit(invalid_params)).to eq(false)
      end
    end
  end
end
