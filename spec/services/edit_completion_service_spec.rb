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

  let(:edited_first_name) { "Foo" }
  let(:edited_last_name) { "Bar" }
  let(:edited_contact_email) { Faker::Internet.email }
  let(:contact_address) { registration.contact_address }

  let(:edit_registration) { create(:edit_registration, :has_finance_details) }
  let(:registration) { WasteCarriersEngine::Registration.find_by(reg_identifier: edit_registration.reg_identifier) }

  let(:reg_orders) { registration.finance_details.orders }
  let(:reg_payments) { registration.finance_details.payments }
  let(:transient_order) { edit_registration.finance_details.orders.first }
  let(:transient_payment) { edit_registration.finance_details.payments.first }
  let(:transient_payments) { [transient_payment] }

  describe ".run" do
    subject(:run_service) { described_class.run(edit_registration: edit_registration, user:) }

    let(:user) { create(:user, role: :agency) }

    before { allow(edit_registration).to receive(:registration_type_changed?).and_return(registration_type_changed) }

    shared_examples "non carrier-type changes" do
      before do
        edit_registration.update(first_name: edited_first_name)
        edit_registration.update(last_name: edited_last_name)
        edit_registration.update(contact_email: edited_contact_email)
        edit_registration.key_people << build(:key_person)
      end

      it "sets the contact address data" do
        run_service

        expect(registration.reload.contact_address.first_name).to eq edited_first_name
        expect(registration.reload.contact_address.last_name).to eq edited_last_name
      end

      it "updates the contact email address" do
        expect { run_service }.to change { registration.reload.contact_email }.to(edited_contact_email)
      end

      it "updates the key people" do
        expect { run_service }.to change { registration.reload.key_people.length }.by(1)
      end

      it "creates a past registration" do
        expect { run_service }.to change { registration.reload.past_registrations.count }.by(1)
      end

      it "increments the certificate version" do
        expect { run_service }.to change { registration.reload.metaData.certificate_version }.by(1)
      end

      it "updates the certificate version history" do
        expect { run_service }.to change { registration.reload.metaData.certificate_version_history.length }.by(1)
      end

      it "records the current user in the version history" do
        expect { run_service }.to change { registration.reload.metaData.certificate_version_history.last["generated_by"] }.to(user.email)
      end

      it "deletes the edit_registration" do
        expect { run_service }.to change(EditRegistration, :count).by(-1)
      end
    end

    context "when the carrier type has not been changed" do
      let(:registration_type_changed) { false }

      it_behaves_like "non carrier-type changes"

      it "does not merge finance details" do
        expect { run_service }.not_to change { registration.reload.finance_details }
      end
    end

    context "when the carrier type has been changed" do
      let(:registration_type_changed) { true }

      it_behaves_like "non carrier-type changes"

      it "updates the balance" do
        expect { run_service }.to change { registration.reload.finance_details.balance }
      end

      it "merges orders" do
        expect { run_service }.to change { registration.reload.finance_details.orders.length }
      end

      it "merges payments" do
        edit_registration.finance_details.payments << build(:payment)

        expect { run_service }.to change { registration.reload.finance_details.payments.length }
      end
    end
  end
end
