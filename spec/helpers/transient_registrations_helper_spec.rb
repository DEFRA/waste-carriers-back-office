# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteCarriersEngine::ApplicationHelper, type: :helper do
  let(:transient_registration) { build(:transient_registration) }

  before do
    assign(:transient_registration, transient_registration)
  end

  describe "#renewal_application_submitted?" do
    context "when the workflow_state is not a completed one" do
      it "returns false" do
        expect(helper.renewal_application_submitted?(transient_registration)).to eq(false)
      end
    end

    context "when the workflow_state is renewal_received" do
      before do
        transient_registration.workflow_state = "renewal_received_form"
      end

      it "returns true" do
        expect(helper.renewal_application_submitted?(transient_registration)).to eq(true)
      end
    end

    context "when the workflow_state is renewal_complete" do
      before do
        transient_registration.workflow_state = "renewal_complete_form"
      end

      it "returns true" do
        expect(helper.renewal_application_submitted?(transient_registration)).to eq(true)
      end
    end
  end

  describe "#show_translation_or_filler" do
    context "when the attribute value is present" do
      before do
        transient_registration.tier = "UPPER"
      end

      it "returns the translation" do
        expect(helper.show_translation_or_filler(:tier)).to eq("Upper")
      end
    end

    context "when the attribute value is not present" do
      before do
        transient_registration.tier = nil
      end

      it "returns the filler" do
        expect(helper.show_translation_or_filler(:tier)).to eq("–")
      end
    end
  end

  describe "#display_current_workflow_state" do
    context "when there is a matching translation" do
      it "returns the translation" do
        expect(helper.display_current_workflow_state).to eq("You are about to renew your registration")
      end
    end

    context "when there is no matching translation" do
      before do
        transient_registration.workflow_state = "foo"
      end

      it "returns the value" do
        expect(helper.display_current_workflow_state).to eq("foo")
      end
    end
  end

  describe "#display_registered_address" do
    context "when there is a registered address" do
      before do
        transient_registration.addresses = [build(:address, :registered)]
      end

      it "returns the required values in an array" do
        array = ["Foo Gardens",
                 "Baz City",
                 "FA1 1KE"]
        expect(helper.display_registered_address).to eq(array)
      end
    end
  end

  describe "#display_contact_address" do
    context "when there is a contact address" do
      before do
        transient_registration.addresses = [build(:address, :contact)]
      end

      it "returns the required values in an array" do
        array = ["Foo Gardens",
                 "Baz City",
                 "FA1 1KE"]
        expect(helper.display_contact_address).to eq(array)
      end
    end
  end

  describe "#key_people_with_conviction_search_results?" do
    context "when there are no key people" do
      before do
        transient_registration.key_people = []
      end

      it "returns false" do
        expect(helper.key_people_with_conviction_search_results?).to eq(false)
      end
    end

    context "when there are key people" do
      let(:person) { build(:key_person) }

      before do
        transient_registration.key_people = [person]
      end

      context "when no person has a conviction search result" do
        before do
          person.conviction_search_result = nil
        end

        it "returns false" do
          expect(helper.key_people_with_conviction_search_results?).to eq(false)
        end
      end

      context "when a person has a conviction search result" do
        before do
          person.conviction_search_result = build(:conviction_search_result)
        end

        it "returns true" do
          expect(helper.key_people_with_conviction_search_results?).to eq(true)
        end
      end
    end
  end

  describe "#number_of_people_with_matching_convictions" do
    context "when there are no key people" do
      before do
        transient_registration.key_people = []
      end

      it "returns 0" do
        expect(helper.number_of_people_with_matching_convictions).to eq(0)
      end
    end

    context "when there is a key person" do
      let(:person) { build(:key_person) }
      before do
        transient_registration.key_people = [person]
      end

      context "when a person has no conviction search result" do
        before do
          person.conviction_search_result = nil
        end

        it "does not count them" do
          expect(helper.number_of_people_with_matching_convictions).to eq(0)
        end
      end

      context "when a conviction search result is NO" do
        before do
          person.conviction_search_result = build(:conviction_search_result, :match_result_no)
        end

        it "does not count them" do
          expect(helper.number_of_people_with_matching_convictions).to eq(0)
        end
      end

      context "when a conviction search result is YES" do
        before do
          person.conviction_search_result = build(:conviction_search_result, :match_result_yes)
        end

        it "counts them" do
          expect(helper.number_of_people_with_matching_convictions).to eq(1)
        end
      end

      context "when a conviction search result is UNKNOWN" do
        before do
          person.conviction_search_result = build(:conviction_search_result, :match_result_unknown)
        end

        it "counts them" do
          expect(helper.number_of_people_with_matching_convictions).to eq(1)
        end
      end
    end
  end
end
