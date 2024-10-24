# frozen_string_literal: true

RSpec.shared_examples "TransientRegistration named scopes" do
  let(:in_progress_renewal) do
    create(:renewing_registration)
  end

  let(:submitted_renewal) do
    create(:renewing_registration,
           workflow_state: :renewal_received_pending_conviction_form)
  end

  let(:pending_payment_renewal) do
    create(:renewing_registration,
           :pending_payment,
           workflow_state: :renewal_received_pending_payment_form)
  end

  let(:pending_approval_renewal) do
    create(:renewing_registration,
           :requires_conviction_check,
           workflow_state: :renewal_received_pending_conviction_form)
  end

  describe "#in_progress" do
    let(:scope) { WasteCarriersEngine::TransientRegistration.in_progress }

    it "returns in progress renewals when they exist" do
      expect(scope).to include(in_progress_renewal)
    end

    it "does not return submitted renewals" do
      expect(scope).not_to include(submitted_renewal)
    end
  end

  describe "#submitted" do
    let(:scope) { WasteCarriersEngine::TransientRegistration.submitted }

    it "returns submitted renewals" do
      expect(scope).to include(submitted_renewal)
    end

    it "does not return in progress renewals" do
      expect(scope).not_to include(in_progress_renewal)
    end
  end

  describe "#pending_payment" do
    let(:scope) { WasteCarriersEngine::TransientRegistration.pending_payment }

    it "returns renewals pending payment" do
      expect(scope).to include(pending_payment_renewal)
    end

    it "does not return others" do
      expect(scope).not_to include(in_progress_renewal)
    end
  end

  describe "#pending_approval" do
    let(:scope) { WasteCarriersEngine::TransientRegistration.pending_approval }

    it "returns renewals pending conviction approval" do
      expect(scope).to include(pending_approval_renewal)
    end

    it "does not return others" do
      expect(scope).not_to include(in_progress_renewal)
    end
  end

  describe "conviction check scopes" do
    let(:convictions_renewal) do
      create(
        :renewing_registration,
        :requires_conviction_check,
        workflow_state: :renewal_received_form
      )
    end

    let(:convictions_possible_match_renewal) do
      convictions_renewal
    end

    let(:convictions_checks_in_progress_renewal) do
      convictions_renewal.conviction_sign_offs.first.begin_checks!
      convictions_renewal
    end

    let(:convictions_approved_renewal) do
      convictions_renewal.conviction_sign_offs.first.approve!(build(:user))
      convictions_renewal
    end

    let(:convictions_rejected_renewal) do
      convictions_renewal.conviction_sign_offs.first.begin_checks!
      convictions_renewal.conviction_sign_offs.first.reject!(build(:user))
      convictions_renewal
    end

    describe "#convictions_possible_match" do
      let(:scope) { WasteCarriersEngine::TransientRegistration.convictions_possible_match }

      it "returns renewals where a conviction_sign_off is in the possible_match state" do
        expect(scope).to include(convictions_possible_match_renewal)
      end

      it "does not return others" do
        expect(scope).not_to include(convictions_checks_in_progress_renewal)
      end
    end

    describe "#convictions_checks_in_progress" do
      let(:scope) { WasteCarriersEngine::TransientRegistration.convictions_checks_in_progress }

      it "returns renewals where a conviction_sign_off is in the checks_in_progress state" do
        expect(scope).to include(convictions_checks_in_progress_renewal)
      end

      it "does not return others" do
        expect(scope).not_to include(convictions_possible_match_renewal)
      end
    end

    describe "#convictions_approved" do
      let(:scope) { WasteCarriersEngine::TransientRegistration.convictions_approved }

      it "returns renewals where a conviction_sign_off is in the approved state" do
        expect(scope).to include(convictions_approved_renewal)
      end

      it "does not return others" do
        expect(scope).not_to include(convictions_possible_match_renewal)
      end
    end

    describe "#convictions_rejected" do
      let(:scope) { WasteCarriersEngine::TransientRegistration.convictions_rejected }

      it "returns renewals where a conviction_sign_off is in the rejected state" do
        expect(scope).to include(convictions_rejected_renewal)
      end

      it "does not return others" do
        expect(scope).not_to include(convictions_possible_match_renewal)
      end
    end
  end
end
