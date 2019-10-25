# frozen_string_literal: true

require "rails_helper"

RSpec.describe StatusTagService do
  let(:service) do
    StatusTagService.run(resource: resource)
  end

  context "when the resource is a registration" do
    let(:resource) { create(:registration) }

    context "when the metadata status is pending" do
      before { resource.metaData.status = "PENDING" }

      it "includes :in_progress in the response" do
        expect(service).to include(:in_progress)
      end
    end

    context "when the metadata status is not pending" do
      let(:status) { %w[ACTIVE EXPIRED REVOKED REFUSED].sample }

      before { resource.metaData.status = status }

      it "includes the status in the response" do
        expect(service).to include(status.downcase.to_sym)
      end
    end

    it "does not include :pending_conviction_check in the response" do
      expect(service).to_not include(:pending_conviction_check)
    end

    context "when there is a pending payment" do
      before { allow(resource).to receive(:pending_payment?).and_return(true) }

      it "includes :pending_payment in the response" do
        expect(service).to include(:pending_payment)
      end
    end

    context "when there is not a pending payment" do
      before { allow(resource).to receive(:pending_payment?).and_return(false) }

      it "does not include :pending_payment in the response" do
        expect(service).to_not include(:pending_payment)
      end
    end

    it "does not include :stuck in the response" do
      expect(service).to_not include(:stuck)
    end
  end

  context "when the resource is a transient_registration" do
    let(:resource) { create(:transient_registration) }

    context "when the metadata status is revoked" do
      before { resource.metaData.status = "REVOKED" }

      it "includes :revoked in the response" do
        expect(service).to include(:revoked)
      end
    end

    context "when the metadata status is refused" do
      before { resource.metaData.status = "REFUSED" }

      it "includes :refused in the response" do
        expect(service).to include(:refused)
      end
    end

    context "when the metadata status is not revoked or refused" do
      let(:status) { %w[ACTIVE EXPIRED PENDING].sample }

      before { resource.metaData.status = status }

      context "when the renewal is not submitted" do
        before { resource.workflow_state = "location_form" }

        it "includes :in_progress in the response" do
          expect(service).to include(:in_progress)
        end
      end

      context "when the renewal is submitted" do
        before { resource.workflow_state = "renewal_received_form" }

        it "does not include a status in the response" do
          expect(service).to_not include(:active)
          expect(service).to_not include(:in_progress)
          expect(service).to_not include(:expired)
          expect(service).to_not include(:pending)
          expect(service).to_not include(:revoked)
          expect(service).to_not include(:refused)
        end
      end
    end

    context "when the renewal is submitted" do
      before { resource.workflow_state = "renewal_received_form" }

      context "when there is a pending conviction check" do
        before { allow(resource).to receive(:pending_manual_conviction_check?).and_return(true) }

        it "includes :pending_conviction_check in the response" do
          expect(service).to include(:pending_conviction_check)
        end
      end

      context "when there is not a pending conviction check" do
        before { allow(resource).to receive(:pending_manual_conviction_check?).and_return(false) }

        it "does not include :pending_conviction_check in the response" do
          expect(service).to_not include(:pending_conviction_check)
        end
      end

      context "when there is a pending payment" do
        before { allow(resource).to receive(:pending_payment?).and_return(true) }

        it "includes :pending_payment in the response" do
          expect(service).to include(:pending_payment)
        end
      end

      context "when there is not a pending payment" do
        before { allow(resource).to receive(:pending_payment?).and_return(false) }

        it "does not include :pending_payment in the response" do
          expect(service).to_not include(:pending_payment)
        end
      end

      context "when the renewal is stuck" do
        before { allow(resource).to receive(:stuck?).and_return(true) }

        it "includes :stuck in the response" do
          expect(service).to include(:stuck)
        end
      end

      context "when the renewal is not stuck" do
        before { allow(resource).to receive(:stuck?).and_return(false) }

        it "does not include :stuck in the response" do
          expect(service).to_not include(:stuck)
        end
      end
    end
  end
end
