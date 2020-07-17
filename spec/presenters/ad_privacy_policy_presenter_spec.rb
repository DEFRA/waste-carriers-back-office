# frozen_string_literal: true

require "rails_helper"

RSpec.describe AdPrivacyPolicyPresenter do

  let(:reg_identifier) { nil }
  let(:token) { nil }
  let(:data_model) { double(:data_model, reg_identifier: reg_identifier, token: token) }

  subject { described_class.new(data_model) }

  describe "destination_path" do
    context "when a 'reg_identifier' is present" do
      let(:reg_identifier) { "CBDUFOO" }

      it "returns the renewal start form path" do
        expect(subject.destination_path).to eq("/bo/CBDUFOO/renew")
      end
    end

    context "when a 'token' is present" do
      let(:token) { create(:new_registration, workflow_state: "business_type_form").token }

      it "returns a resume link for the given transient resource" do
        expect(subject.destination_path).to eq("/bo/#{token}/business-type")
      end
    end

    context "when neither 'reg_identifier' nor 'token' are present" do
      it "returns a new registration start form path to the back-office" do
        expect(subject.destination_path).to eq("/bo/start")
      end
    end
  end
end
