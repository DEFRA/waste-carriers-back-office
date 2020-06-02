# frozen_string_literal: true

require "rails_helper"

RSpec.describe BaseRegistrationPresenter do
  let(:registration) { double(:registration) }
  let(:view_context) { double(:view_context) }
  subject { described_class.new(registration, view_context) }

  describe "#in_progress?" do
    it "returns false" do
      expect(subject).to_not be_in_progress
    end
  end

  describe "#show_no_finance_details_data?" do
    before do
      expect(registration).to receive(:upper_tier?).and_return(upper_tier)
    end

    context "when the registration is an upper tier" do
      let(:upper_tier) { true }

      before do
        expect(registration).to receive(:finance_details).and_return(finance_details)
      end

      context "when finance details object is missing" do
        let(:finance_details) { nil }

        it "returns true" do
          expect(subject.show_no_finance_details_data?).to be_truthy
        end
      end

      context "when finance details object is present" do
        let(:finance_details) { "Something" }

        it "returns false" do
          expect(subject.show_no_finance_details_data?).to be_falsey
        end
      end
    end

    context "when the registration is a lower tier registration" do
      let(:upper_tier) { false }

      it "returns false" do
        expect(subject.show_no_finance_details_data?).to be_falsey
      end
    end
  end

  describe "#finance_details_balance" do
    it "returns the finance details balance" do
      finance_details = double(:finance_details)
      balance = double(:balance)

      expect(registration).to receive(:finance_details).and_return(finance_details)
      expect(finance_details).to receive(:balance).and_return(balance)

      expect(subject.finance_details_balance).to eq(balance)
    end
  end

  describe "#show_ceased_revoked_panel?" do
    let(:revoked) { false }
    let(:inactive) { false }
    let(:registration) do
      double(
        :registration,
        revoked?: revoked,
        inactive?: inactive
      )
    end

    context "when it is neither revoked nor inactive" do
      it "returns false" do
        expect(subject.show_ceased_revoked_panel?).to be_falsey
      end
    end

    context "when it is revoked" do
      let(:revoked) { true }

      it "returns true" do
        expect(subject.show_ceased_revoked_panel?).to be_truthy
      end
    end

    context "when it is inactive" do
      let(:inactive) { true }

      it "returns true" do
        expect(subject.show_ceased_revoked_panel?).to be_truthy
      end
    end
  end

  describe "#ceased_revoked_header" do
    let(:revoked) { false }
    let(:inactive) { false }
    let(:registration) do
      double(
        :registration,
        revoked?: revoked,
        inactive?: inactive
      )
    end

    context "when it is neither revoked nor inactive" do
      it "returns nil" do
        expect(subject.ceased_revoked_header).to be_nil
      end
    end

    context "when it is revoked" do
      let(:revoked) { true }

      it "returns 'Revoked'" do
        header = "Revoked"

        expect(subject.ceased_revoked_header).to eq(header)
      end
    end

    context "when it is inactive" do
      let(:inactive) { true }

      it "returns 'Ceased'" do
        header = "Ceased"

        expect(subject.ceased_revoked_header).to eq(header)
      end
    end
  end

  describe "#latest_order" do
    let(:latest_order) { double(:order) }
    let(:registration) do
      double(
        :registration,
        finance_details: double(:finance_details, orders: double(:orders))
      )
    end

    it "returns the last order in the list of finance details orders" do
      scope = double(:scope)
      expect(registration.finance_details.orders).to receive(:order_by).with(dateCreated: :desc).and_return(scope)
      expect(scope).to receive(:first).and_return(latest_order)

      expect(subject.latest_order).to eq(latest_order)
    end
  end

  describe "#show_order_details?" do
    let(:upper_tier) { true }
    let(:finance_details) { double(:finance_details, orders: orders) }
    let(:registration) do
      double(
        :registration,
        finance_details: finance_details,
        upper_tier?: upper_tier
      )
    end

    context "when there are orders available" do
      let(:orders) { [double(:order)] }

      context "when the registration is an upper tier" do
        it "returns true" do
          expect(subject.show_order_details?).to be_truthy
        end
      end

      context "when the registration is a lower tier" do
        let(:upper_tier) { false }

        it "returns false" do
          expect(subject.show_order_details?).to be_falsey
        end
      end
    end

    context "when there are no orders details available" do
      let(:orders) { [] }

      it "returns false" do
        expect(subject.show_order_details?).to be_falsey
      end
    end
  end

  describe "#displayable_location" do
    let(:registration) { double(:registration, location: location) }

    context "when there is no location value" do
      let(:location) { nil }

      it "displays a placeholder" do
        expect(subject.displayable_location).to eq("Place of business: –")
      end
    end

    context "when there is a location value" do
      let(:location) { "england" }

      it "displays the location value" do
        expect(subject.displayable_location).to eq("Place of business: England")
      end
    end
  end

  describe "#display_convictions_check_message" do
    context "when the registration is a lower tier registration" do
      let(:registration) { double(:registration, lower_tier?: true) }

      it "returns the lower tier text" do
        message = "Lower tier registration - convictions are not applicable."

        expect(subject.display_convictions_check_message).to eq(message)
      end
    end

    context "when the registration has convictions checks approved" do
      let(:registration) { double(:registration, conviction_check_approved?: true, lower_tier?: false) }

      it "returns the convictions checks approved message" do
        message = "This registration was approved after a review of the matching or declared convictions."

        expect(subject.display_convictions_check_message).to eq(message)
      end
    end

    context "when the registration has convictions checks rejected" do
      let(:registration) do
        double(
          :registration,
          conviction_check_approved?: false,
          lower_tier?: false,
          rejected_conviction_checks?: true
        )
      end

      it "returns the convictions checks rejected message" do
        message = "This registration was rejected after a review of the matching or declared convictions."

        expect(subject.display_convictions_check_message).to eq(message)
      end
    end

    context "when the registration has convictions checks results" do
      let(:registration) do
        double(
          :registration,
          conviction_check_approved?: false,
          lower_tier?: false,
          rejected_conviction_checks?: false,
          conviction_search_result: double(:conviction_search_result),
          conviction_check_required?: conviction_check_required
        )
      end

      context "when a convictions check is required" do
        let(:conviction_check_required) { true }

        it "returns the convictions checks required message" do
          message = "This registration has matching or declared convictions."

          expect(subject.display_convictions_check_message).to eq(message)
        end
      end

      context "when a convictions check is not required" do
        let(:conviction_check_required) { false }

        it "returns the convictions checks not required message" do
          message = "There are no convictions for this registration."

          expect(subject.display_convictions_check_message).to eq(message)
        end
      end

      context "when we are unable to determine the status of convictions checks" do
        let(:registration) do
          double(
            :registration,
            conviction_check_approved?: false,
            lower_tier?: false,
            rejected_conviction_checks?: false,
            conviction_search_result: nil
          )
        end

        it "returns an unknown message" do
          message = "This registration application is still in progress, so there is no conviction match data yet."

          expect(subject.display_convictions_check_message).to eq(message)
        end
      end
    end
  end

  describe "#display_expiry_text" do
    let(:upper_tier) { false }
    let(:expired) { false }
    let(:expires_on) { nil }
    let(:registration) do
      double(
        :registration,
        expired?: expired,
        upper_tier?: upper_tier,
        expires_on: expires_on,
        display_expiry_date: "1 January 2020"
      )
    end

    context "when the registration has no expiry date" do
      it "returns nil" do
        expect(subject.display_expiry_text).to eq(nil)
      end
    end

    context "when the registration is not upper tier" do
      it "returns nil" do
        expect(subject.display_expiry_text).to eq(nil)
      end
    end

    context "when the registration has an expiry date and is upper tier" do
      let(:expires_on) { Date.new(2020, 1, 1) }
      let(:upper_tier) { true }

      context "when it is not expired" do
        it "displays the 'expires' message" do
          message = "Expires: 1 January 2020"

          expect(subject.display_expiry_text).to eq(message)
        end
      end

      context "when it is expired" do
        let(:expired) { true }

        it "displays the 'expired' message" do
          message = "Expired: 1 January 2020"

          expect(subject.display_expiry_text).to eq(message)
        end
      end
    end
  end

  describe "#display_action_links_heading" do
    let(:reg_identifier) { "CBDU1234" }
    let(:registration) do
      double(:registration,
             reg_identifier: reg_identifier)
    end

    it "returns a heading with the reg_identifier" do
      result = subject.display_action_links_heading

      expect(result).to eq("Actions for CBDU1234")
    end
  end
end
