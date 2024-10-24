# frozen_string_literal: true

require "rails_helper"

module WasteCarriersEngine
  RSpec.describe ConvictionSignOff do
    let(:transient_registration) { build(:renewing_registration, :requires_conviction_check) }
    let(:conviction_sign_off) { transient_registration.conviction_sign_offs.first }
    let(:user) { build(:user) }

    describe "#workflow_state" do
      context "when a conviction_sign_off is created" do
        it "has the workflow_state 'possible_match'" do
          expect(conviction_sign_off.workflow_state).to eq("possible_match")
        end
      end

      context "when the conviction_sign_off workflow_state is 'possible_match'" do
        let(:conviction_sign_off) { build(:conviction_sign_off, :possible_match) }

        it "can begin checks" do
          expect(conviction_sign_off).to allow_event :begin_checks
        end

        it "can be approved" do
          expect(conviction_sign_off).to allow_event :approve
        end

        it "cannot be rejected" do
          expect(conviction_sign_off).not_to allow_event :reject
        end
      end

      context "when the conviction_sign_off workflow_state is 'checks_in_progress'" do
        let(:conviction_sign_off) { build(:conviction_sign_off, :checks_in_progress) }

        it "cannot begin checks" do
          expect(conviction_sign_off).not_to allow_event :begin_checks
        end

        it "can be approved" do
          expect(conviction_sign_off).to allow_event :approve
        end

        it "can be rejected" do
          expect(conviction_sign_off).to allow_event :reject
        end
      end

      context "when the conviction_sign_off workflow_state is 'approved'" do
        let(:conviction_sign_off) { build(:conviction_sign_off, :approved) }

        it "cannot begin checks" do
          expect(conviction_sign_off).not_to allow_event :begin_checks
        end

        it "cannot be approved" do
          expect(conviction_sign_off).not_to allow_event :approve
        end

        it "cannot be rejected" do
          expect(conviction_sign_off).not_to allow_event :reject
        end
      end

      context "when the conviction_sign_off workflow_state is 'rejected'" do
        let(:conviction_sign_off) { build(:conviction_sign_off, :rejected) }

        it "cannot begin checks" do
          expect(conviction_sign_off).not_to allow_event :begin_checks
        end

        it "cannot be approved" do
          expect(conviction_sign_off).not_to allow_event :approve
        end

        it "cannot be rejected" do
          expect(conviction_sign_off).not_to allow_event :reject
        end
      end

      context "when the approve event happens" do
        before do
          conviction_sign_off.approve(user)
        end

        it "updates confirmed" do
          expect(conviction_sign_off.confirmed).to eq("yes")
        end

        it "updates confirmed_at" do
          expect(conviction_sign_off.confirmed_at).to be_a(DateTime)
        end

        it "updates confirmed_by" do
          expect(conviction_sign_off.confirmed_by).to eq(user.email)
        end
      end

      context "when the reject event happens" do
        before do
          conviction_sign_off.workflow_state = "checks_in_progress"
        end

        it "does not update confirmed" do
          expect(conviction_sign_off.confirmed).to eq("no")
        end

        it "updates confirmed_at" do
          conviction_sign_off.reject(user)
          expect(conviction_sign_off.confirmed_at).to be_a(DateTime)
        end

        it "updates confirmed_by" do
          conviction_sign_off.reject(user)
          expect(conviction_sign_off.confirmed_by).to eq(user.email)
        end

        context "when the metaData status is pending" do
          before { transient_registration.metaData.status = :PENDING }

          it "updates the metaData status to refused" do
            conviction_sign_off.reject(user)
            expect(transient_registration.metaData.status).to eq("REFUSED")
          end
        end

        context "when the metaData status is not pending" do
          before { transient_registration.metaData.status = :ACTIVE }

          it "updates the metaData status to revoked" do
            conviction_sign_off.reject(user)
            expect(transient_registration.metaData.status).to eq("REVOKED")
          end
        end
      end
    end
  end
end
