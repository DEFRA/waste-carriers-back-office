# frozen_string_literal: true

require "rails_helper"

RSpec.describe EditCompletionService do
  let(:copyable_attributes) do
    {
      # Don't include all attributes - we just need to have some examples
      "addresses" => {},
      "contact_email" => nil,
      "keyPeople" => {}
    }
  end
  let(:uncopyable_attributes) do
    {
      "_id" => nil,
      "token" => nil,
      "accountEmail" => nil,
      "created_at" => nil,
      "expires_on" => nil,
      "financeDetails" => nil,
      "temp_cards" => nil,
      "temp_company_postcode" => nil,
      "temp_contact_postcode" => nil,
      "temp_os_places_error" => nil,
      "temp_payment_method" => nil,
      "_type" => nil,
      "workflow_state" => nil
    }
  end
  let(:attributes) do
    copyable_attributes.merge(uncopyable_attributes)
  end

  let(:first_name) { "Foo" }
  let(:last_name) { "Bar" }
  let(:contact_address) { instance_double(WasteCarriersEngine::Address) }

  let(:reg_finance_details) { instance_double(WasteCarriersEngine::FinanceDetails) }
  let(:transient_finance_details) { instance_double(WasteCarriersEngine::FinanceDetails) }

  let(:registration_type_changed) { false }

  let(:registration) { instance_double(WasteCarriersEngine::Registration, finance_details: reg_finance_details) }

  let(:edit_registration) do
    instance_double(EditRegistration,
                    attributes: attributes,
                    registration: registration,
                    contact_address: contact_address,
                    first_name: first_name,
                    last_name: last_name,
                    finance_details: transient_finance_details,
                    registration_type_changed?: registration_type_changed)
  end

  let(:reg_orders) { [instance_double(WasteCarriersEngine::Order)] }
  let(:reg_payments) { [instance_double(WasteCarriersEngine::Payment)] }
  let(:transient_order) { instance_double(WasteCarriersEngine::Order) }
  let(:transient_payment) { instance_double(WasteCarriersEngine::Payment) }
  let(:transient_payments) { [transient_payment] }

  describe ".run" do
    before do
      allow(contact_address).to receive(:first_name=)
      allow(contact_address).to receive(:last_name=)
      allow(edit_registration).to receive(:delete)
      allow(WasteCarriersEngine::PastRegistration).to receive(:build_past_registration)
      allow(registration).to receive(:save!)
      allow(registration).to receive(:write_attributes)
      allow(reg_finance_details).to receive_messages(orders: reg_orders, payments: reg_payments)
      allow(reg_finance_details).to receive(:update_balance)
      allow(reg_orders).to receive(:<<).with(transient_order)
      allow(reg_payments).to receive(:<<).with(transient_payment)
      allow(transient_finance_details).to receive(:payments).and_return([transient_payment]).twice
      allow(transient_finance_details).to receive_messages(orders: [transient_order], payments: transient_payments)
    end

    context "when given an edit_registration" do
      it "updates the registration without merging finance details and deletes the edit_registration" do

        described_class.run(edit_registration: edit_registration)

        # Sets up the contact address data
        expect(contact_address).to have_received(:first_name=).with(first_name)
        expect(contact_address).to have_received(:last_name=).with(last_name)

        # Creates a past_registration
        expect(WasteCarriersEngine::PastRegistration).to have_received(:build_past_registration).with(registration, :edit)

        # Updates the registration
        expect(registration).to have_received(:write_attributes).with(copyable_attributes)

        # Does not merge finance details
        expect(reg_finance_details).not_to have_received(:update_balance)

        # Saves the registration
        expect(registration).to have_received(:save!)

        # Deletes transient registration
        expect(edit_registration).to have_received(:delete)
      end

      context "when the carrier type has changed" do
        let(:registration_type_changed) { true }

        it "updates the registration, merges finance details and deletes the edit_registration" do

          described_class.run(edit_registration: edit_registration)

          # Sets up the contact address data
          expect(contact_address).to have_received(:first_name=).with(first_name)
          expect(contact_address).to have_received(:last_name=).with(last_name)

          # Creates a past_registration
          expect(WasteCarriersEngine::PastRegistration).to have_received(:build_past_registration).with(registration, :edit)

          # Updates the registration
          expect(registration).to have_received(:write_attributes).with(copyable_attributes)

          # Updates the balance
          expect(reg_finance_details).to have_received(:update_balance)

          # Merges orders
          expect(reg_orders).to have_received(:<<).with(transient_order)

          # Merges payments
          expect(reg_payments).to have_received(:<<).with(transient_payment)

          # Saves the registration
          expect(registration).to have_received(:save!)

          # Deletes transient registration
          expect(edit_registration).to have_received(:delete)
        end
      end
    end
  end
end
