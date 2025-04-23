# frozen_string_literal: true

require "rails_helper"

RSpec.describe EditForm do
  subject(:edit_registration) { build(:edit_registration) }

  describe "#workflow_state" do
    context "with :edit_form state transitions" do
      current_state = :edit_form
      non_address_editable_form_states = %i[
        cbd_type_form
        company_name_form
        main_people_form
        contact_name_form
        contact_phone_form
        contact_email_form
      ]
      transitionable_states = non_address_editable_form_states + %i[company_postcode_form
                                                                    contact_postcode_form
                                                                    declaration_form
                                                                    confirm_edit_cancelled_form]

      context "when an EditRegistration's state is #{current_state}" do
        it "can only transition to the allowed states" do
          permitted_states = Helpers::WorkflowStates.permitted_states(edit_registration)
          expect(permitted_states).to match_array(transitionable_states)
        end

        non_address_editable_form_states.each do |expected_state|
          state_without_form_suffix = expected_state.to_s.remove("_form")
          event = :"edit_#{state_without_form_suffix}"

          it "changes to #{expected_state} after the '#{event}' event" do
            expect(edit_registration).to transition_from(current_state).to(expected_state).on_event(event)
          end
        end

        context "when the registration is not overseas" do
          before { edit_registration.location = "england" }

          it "changes to :company_postcode_form after the 'edit_company_address' event" do
            expect(edit_registration).to transition_from(current_state).to(:company_postcode_form).on_event(:edit_company_address)
          end

          it "changes to :contact_postcode_form after the 'edit_contact_address' event" do
            expect(edit_registration).to transition_from(current_state).to(:contact_postcode_form).on_event(:edit_contact_address)
          end
        end

        context "when the registration is overseas" do
          before { edit_registration.location = "overseas" }

          it "changes to :company_address_manual_form after the 'edit_company_address' event" do
            expect(edit_registration).to transition_from(current_state).to(:company_address_manual_form).on_event(:edit_company_address)
          end

          it "changes to :contact_address_manual_form after the 'edit_contact_address' event" do
            expect(edit_registration).to transition_from(current_state).to(:contact_address_manual_form).on_event(:edit_contact_address)
          end
        end

        it "changes to confirm_edit_cancelled after the 'cancel_edit' event" do
          expected_state = :confirm_edit_cancelled_form
          event = :cancel_edit
          expect(edit_registration).to transition_from(current_state).to(expected_state).on_event(event)
        end

        context "with :next transition" do
          it_behaves_like "has next transition", next_state: "declaration_form"
        end
      end
    end
  end
end
