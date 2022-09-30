# frozen_string_literal: true

require "rails_helper"

RSpec.describe NewRegistrationPresenter do
  subject { described_class.new(new_registration, view_context) }

  let(:new_registration) { double(:new_registration) }
  let(:view_context) { double(:view_context) }

  describe "#display_heading" do
    let(:new_registration) { double(:new_registration, company_name: company_name) }

    context "when there is a company_name" do
      let(:company_name) { "Foo" }

      it "returns a heading with the name" do
        result = subject.display_heading

        expect(result).to eq("New registration for Foo")
      end
    end

    context "when there is no company_name" do
      let(:company_name) { nil }

      it "returns a heading without a name" do
        result = subject.display_heading

        expect(result).to eq("New registration")
      end
    end
  end

  describe "#display_current_workflow_state" do
    let(:workflow_state) { "a_workflow_state" }
    let(:new_registration) { double(:new_registration, workflow_state: workflow_state) }

    it "returns a displayable current workflow state string" do
      result = subject.display_current_workflow_state

      expect(result).to eq('The current form is "a_workflow_state"')
    end
  end

  describe "#display_action_links_heading" do
    let(:company_name) { nil }
    let(:new_registration) do
      double(:new_registration,
             company_name: company_name)
    end

    context "when there is a company_name" do
      let(:company_name) { "Foo" }

      it "returns a heading with the name" do
        result = subject.display_action_links_heading

        expect(result).to eq("Actions for Foo")
      end
    end

    context "when there is no company_name" do
      it "returns a heading without a name" do
        result = subject.display_action_links_heading

        expect(result).to eq("Actions")
      end
    end
  end
end
