# frozen_string_literal: true

require "rails_helper"

def mix_case(str)
  "#{str[0..2].upcase}#{str[3..5].downcase}#{str.from(6)}"
end

RSpec.describe ClearNcccContactEmailsService do

  describe ".run" do

    subject { described_class.run }

    let(:contact_email) { "-" }
    let(:registration) { create(:registration, contact_email: contact_email) }

    shared_examples "clears the contact_email" do |base_contact_email|

      context "with upper case (#{base_contact_email})" do
        let(:contact_email) { base_contact_email.upcase }

        it "sets contact_email to nil" do
          expect { subject }.to change { registration.reload.contact_email }.to(nil)
        end
      end

      context "with lower case (#{base_contact_email})" do
        let(:contact_email) { base_contact_email.downcase }

        it "sets contact_email to nil" do
          expect { subject }.to change { registration.reload.contact_email }.to(nil)
        end
      end

      context "with mixed case (#{base_contact_email})" do
        let(:contact_email) { mix_case(base_contact_email.to_s) }

        it "sets contact_email to nil" do
          expect { subject }.to change { registration.reload.contact_email }.to(nil)
        end
      end
    end

    shared_examples "does not clear the contact_email" do |contact_email|
      it "does not change the contact_email (#{contact_email})" do
        expect { subject }.not_to change { registration.reload.contact_email }
      end
    end

    context "with correct NCCC email addresses as contact_email" do
      it_behaves_like "clears the contact_email", "nccc@environment-agency.gov.uk"
      it_behaves_like "clears the contact_email", "nccc-carrierbroker@environment-agency.gov.uk"
    end

    context "with positive-match variants in the contact_email" do
      emails_to_clear = %i[
        carrierbroker@environment-agency.gov.uk
        carrier-broker@environment-agency.gov.uk
        ccc-carrierbroker@environment-agency.gov.uk
        ccscoaching@environment-agency.gov.uk
        ncc@environment-agency.gov.uk
        nccc@environment-agency.gov.uk
        ncc-carrierbroker@environment-agency.gov.uk
        ncc-carrierbrokerdealer@environment-agency.gov.uk
        nccc-carierbroker@environment-agency.gov.uk
        nccc-carrier@environment-agency.gov.uk
        nccc-carrierbokrer@environment-agency.gov.uk
        nccc-carrierborker@environment-agency.gov.uk
        nccc-carrierborker@evironment-agency.gov.uk
        nccc-carrierbrocker@environment-agency.gov.uk
        nccc-carrierbrocker@envronmnet-agency.gov.uk
        nccc-carrierbroke@environment-agency.gov.uk
        nccc-carrierbroker@agency.gov.uk
        nccc-carrierbroker@envionment-agency.gov.uk
        nccc-carrierbroker@environemnt-agency.gov.uk
        nccccarrierbroker@environment-agency.gov.uk
        nccccarrierbroker-@environment-agency.gov.uk
        nccc-carrierbroker@environmentagency.gov.uk
        nccc-carrierbroker@environment-agency.gov.uk
        nccc-carrier-broker@environment-agency.gov.uk
        -nccc-carrierbroker@environment-agency.gov.uk
        nccc-carrierbroker@environment-agency-gov.uk
        nccc-carrierbroker@environmment-agency.gov.uk
        nccc-carrierbroker@environonment-agency.gov.uk
        nccc-carrierbrokers@environmentagency.gov.uk
        nccc-carrierbrokers@environment-agency.gov.uk
        nccc-carrierbrokers@environmentalagency.gov.uk
        nccc-carrierdealer@environment-agency.gov.uk
        nccc-carriers@environment-agency.gov.uk
        nccc-carriersbroker@environment-agency.gov.uk
        nccc-wastecarrier@environment-agency.gov.uk
        ncccwastecarriers@environment-agency.gov.uk
        nccc-wastecarriers@environment-agency.gov.uk
        nccc-waste-carriers@environment-agency.gov.uk
        wastecarriers@environment-agency.gov.uk
        waste-exemptions@environment-agency.gov.uk
      ]

      emails_to_clear.each do |email|
        it_behaves_like "clears the contact_email", email
      end
    end

    context "with negative-match variants in the contact_email" do
      emails_to_keep = %i[
        jane.doe@environment-agency.gov.uk
        sue.someone@environment-agency.gov.uk
        test@environment-agency.gov.uk
      ]
      emails_to_keep.each do |email|
        it_behaves_like "does not clear the contact_email", email
      end
    end
  end
end
