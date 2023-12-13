# frozen_string_literal: true

RSpec.shared_examples "a manual address transition" do |next_state:, address_type:, factory:|
  describe "#workflow_state" do
    current_state = "#{address_type}_address_manual_form".to_sym
    subject do
      build(factory, workflow_state: current_state, location: location,
                     tier: defined?(tier) ? tier : WasteCarriersEngine::Registration::UPPER_TIER)
    end

    context "when subject.overseas? is false" do
      let(:location) { "england" }

      it "can only transition to either #{next_state}" do
        permitted_states = Helpers::WorkflowStates.permitted_states(subject)

        expect(permitted_states).to contain_exactly(next_state)
      end

      it "changes to #{next_state} after the 'next' event" do
        expect(subject).to transition_from(current_state).to(next_state).on_event(:next)
      end
    end

    context "when subject.overseas? is true" do
      let(:location) { "overseas" }

      it "can only transition to #{next_state}" do
        permitted_states = Helpers::WorkflowStates.permitted_states(subject)

        expect(permitted_states).to match_array([next_state].uniq)
      end

      it "changes to #{next_state} after the 'next' event" do
        expect(subject).to transition_from(current_state).to(next_state).on_event(:next)
      end
    end
  end
end
