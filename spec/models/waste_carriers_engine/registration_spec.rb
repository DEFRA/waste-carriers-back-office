# frozen_string_literal: true

require "rails_helper"

module WasteCarriersEngine
  RSpec.describe Registration do

    describe "#can_start_front_office_renewal?" do
      let(:registration) { build(:registration) }

      context "when the registration is lower tier" do
        before { registration.tier = "LOWER" }

        it "returns false" do
          expect(registration.can_start_front_office_renewal?).to be(false)
        end
      end

      context "when the registration is upper tier" do
        before { registration.tier = "UPPER" }

        context "when the registration has been revoked or refused" do
          before { registration.metaData.status = %w[REVOKED REFUSED].sample }

          it "returns false" do
            expect(registration.can_start_front_office_renewal?).to be(false)
          end
        end

        context "when the registration has not been revoked or refused" do
          before { registration.metaData.status = "ACTIVE" }

          context "when there is no expires_on" do
            before { registration.expires_on = nil }

            it "returns false" do
              expect(registration.can_start_front_office_renewal?).to be(false)
            end
          end

          context "when there is an expires_on" do
            let(:expiry_check_service) { instance_double(ExpiryCheckService) }

            before do
              allow(ExpiryCheckService).to receive(:new).and_return(expiry_check_service)

              registration.expires_on = 1.day.from_now
            end

            context "when the registration is in the standard grace window" do
              before { allow(expiry_check_service).to receive(:in_expiry_grace_window?).and_return(true) }

              it "returns true" do
                expect(registration.can_start_front_office_renewal?).to be(true)
              end
            end

            context "when the registration is not in the standard grace window" do
              before { allow(expiry_check_service).to receive(:in_expiry_grace_window?).and_return(false) }

              context "when the registration is past the expiry date" do
                before { allow(expiry_check_service).to receive(:expired?).and_return(true) }

                it "returns false" do
                  expect(registration.can_start_front_office_renewal?).to be(false)
                end
              end

              context "when the registration is not past the expiry date" do
                before { allow(expiry_check_service).to receive(:expired?).and_return(false) }

                context "when the registration is in the renewal window" do
                  before { allow(expiry_check_service).to receive(:in_renewal_window?).and_return(true) }

                  it "returns true" do
                    expect(registration.can_start_front_office_renewal?).to be(true)
                  end
                end

                context "when the result is not in the renewal window" do
                  before { allow(expiry_check_service).to receive(:in_renewal_window?).and_return(false) }

                  it "returns false" do
                    expect(registration.can_start_front_office_renewal?).to be(false)
                  end
                end
              end
            end
          end
        end
      end
    end

    describe "#increment_certificate_version" do
      let(:user) { create(:user) }

      context "when version is already present" do
        let(:meta_data) { build(:metaData, certificateVersion: 1, certificateVersionHistory: [{ foo: :bar }]) }
        let(:registration) { create(:registration, metaData: meta_data) }

        it "increments verson number by 1" do
          registration.increment_certificate_version(user)
          expect(registration.metaData.certificate_version).to eq(2)
        end

        it "updates certificate_version_history" do
          registration.increment_certificate_version(user)
          expect(registration.metaData.certificate_version_history.length).to eq 2
          expect(registration.metaData.certificate_version_history.last[:version]).to eq(2)
          expect(registration.metaData.certificate_version_history.last[:generated_by]).to eq(user.email)
          expect(registration.metaData.certificate_version_history.last[:generated_at]).to be_present
        end
      end

      context "when version has not been set" do
        let(:meta_data) { build(:metaDataEmpty) }
        let(:registration) { create(:registration, metaData: meta_data) }

        # The version must default to 1 for historic registrations created before versioning go-live
        it "defaults to 1" do
          expect(meta_data.certificate_version).to eq 1
        end

        it "keeps the version at 1" do
          registration.increment_certificate_version(user)
          expect(registration.metaData.certificate_version).to eq(1)
        end

        it "updates certificate_version_history" do
          registration.increment_certificate_version(user)
          expect(registration.metaData.certificate_version_history.length).to eq 1
          expect(registration.metaData.certificate_version_history.last[:version]).to eq(1)
          expect(registration.metaData.certificate_version_history.last[:generated_by]).to eq(user.email)
          expect(registration.metaData.certificate_version_history.last[:generated_at]).to be_present
        end
      end
    end
  end
end
