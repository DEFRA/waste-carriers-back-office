# frozen_string_literal: true

RSpec.describe BaseRegistrationPresenter do
  let(:registration) { double(:registration) }
  let(:view_context) { double(:view_context) }
  subject { described_class.new(registration, view_context) }

  describe "#order" do
    let(:order) { double(:order) }
    let(:registration) do
      double(
        :registration,
        finance_details: double(:finance_details, orders: [order])
      )
    end

    it "returns the first order in the list of finance details orders" do
      expect(subject.order).to eq(order)
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

  describe "#show_finance_details_link?" do
    let(:upper_tier) { true }
    let(:registration) do
      double(
        :registration,
        finance_details: finance_details,
        upper_tier?: upper_tier
      )
    end

    context "when there are finance details available" do
      let(:finance_details) { double(:finance_details) }

      context "when the registration is an upper tier" do
        it "returns true" do
          expect(subject.show_finance_details_link?).to be_truthy
        end
      end

      context "when the registration is a lower tier" do
        let(:upper_tier) { false }

        it "returns false" do
          expect(subject.show_finance_details_link?).to be_falsey
        end
      end
    end

    context "when there are no finance details available" do
      let(:finance_details) { nil }

      it "returns false" do
        expect(subject.show_finance_details_link?).to be_falsey
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
end
