# frozen_string_literal: true

require "rails_helper"

RSpec.describe EditRegistration do
  subject(:edit_registration) { build(:edit_registration) }

  it_behaves_like "Can check if registration type changed"

  context "with default status" do
    context "when an EditRegistration is created" do
      it "has the state of :edit_form" do
        expect(edit_registration).to have_state(:edit_form)
      end
    end
  end

  context "with validations" do
    describe "reg_identifier" do
      context "when an EditRegistration is created" do
        it "is not valid if the reg_identifier is in the wrong format" do
          edit_registration.reg_identifier = "foo"
          expect(edit_registration).not_to be_valid
        end

        it "is not valid if no matching registration exists" do
          edit_registration.reg_identifier = "CBDU999999"
          expect(edit_registration).not_to be_valid
        end
      end
    end
  end

  describe "#initialize" do
    context "when it is initialized with a registration" do
      let(:registration) { create(:registration) }
      let(:edit_registration) { described_class.new(reg_identifier: registration.reg_identifier) }

      copyable_properties = WasteCarriersEngine::Registration.attribute_names - %w[_id
                                                                                   accountEmail
                                                                                   addresses
                                                                                   expires_on
                                                                                   key_people
                                                                                   financeDetails
                                                                                   conviction_search_result
                                                                                   conviction_sign_offs
                                                                                   declaration
                                                                                   past_registrations
                                                                                   copy_cards]

      copyable_properties.each do |property|
        it "copies #{property} from the registration" do
          expect(edit_registration[property]).to eq(registration[property])
        end
      end

      it "copies the addresses from the registration" do
        registration.addresses.each_with_index do |address, index|
          copyable_attributes = address.attributes.except("_id")
          expect(edit_registration.addresses[index].attributes).to include(copyable_attributes)
        end
      end

      it "copies the key_people from the registration" do
        registration.key_people.each_with_index do |person, index|
          copyable_attributes = person.attributes.except("_id",
                                                         "conviction_search_result")
          expect(edit_registration.key_people[index].attributes).to include(copyable_attributes)
        end
      end
    end
  end

  describe "#prepare_for_payment" do
    before { allow(BuildEditFinanceDetailsService).to receive(:run) }

    it "runs the EditFinanceDetailsBuilderService with the correct params" do
      mode = "OFFLINE"
      user = instance_double(described_class, :user)

      edit_registration.prepare_for_payment(mode, user)

      expect(BuildEditFinanceDetailsService).to have_received(:run).with(
        user: user,
        transient_registration: edit_registration,
        payment_method: mode
      )
    end
  end

  describe "#location_changed_from_overseas?" do
    context "when the registration is has an overseas location" do
      before { edit_registration.registration.location = "overseas" }

      context "when the edit_registration has a UK location" do
        before { edit_registration.location = "england" }

        it "returns true" do
          expect(edit_registration).to be_location_changed_from_overseas
        end
      end

      context "when the edit_registration does not have a UK location" do
        before { edit_registration.location = "overseas" }

        it "returns false" do
          expect(edit_registration).not_to be_location_changed_from_overseas
        end
      end
    end

    context "when the registration is has an overseas business type" do
      before { edit_registration.registration.business_type = "overseas" }

      context "when the edit_registration has a UK location" do
        before { edit_registration.location = "england" }

        it "returns true" do
          expect(edit_registration).to be_location_changed_from_overseas
        end
      end

      context "when the edit_registration does not have a UK location" do
        before { edit_registration.location = "overseas" }

        it "returns false" do
          expect(edit_registration).not_to be_location_changed_from_overseas
        end
      end
    end

    context "when the registration is not overseas" do
      before { edit_registration.registration.location = "england" }

      it "returns false" do
        expect(edit_registration).not_to be_location_changed_from_overseas
      end
    end
  end

  describe ".temp_attributes" do
    it "returns all attributes with names starting with 'temp_'" do
      instance_temp_attrs = described_class.attribute_names.select { |a| a.start_with?("temp_") }
      expect(described_class.temp_attributes).to match_array(instance_temp_attrs)
    end

    it "does not return any attributes with names which do not start with 'temp_'" do
      expect(described_class.temp_attributes).to all(start_with("temp_"))
    end
  end
end
