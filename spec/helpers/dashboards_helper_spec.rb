# frozen_string_literal: true

require "rails_helper"

RSpec.describe DashboardsHelper do
  let(:result) { build(:renewing_registration) }

  describe "#inline_registration_address" do
    context "when the address is not present" do
      before do
        result.addresses = nil
      end

      it "returns nil" do
        expect(helper.inline_registered_address(result)).to be_nil
      end
    end

    context "when the address is present" do
      it "returns the correct value" do
        reg_address = result.addresses.select { |a| a.address_type == "REGISTERED" }.first
        expect(helper.inline_registered_address(result).split(/\s*,\s*/))
          .to include(reg_address.house_number,
                      reg_address.address_line_1,
                      reg_address.town_city,
                      reg_address.postcode)
      end
    end
  end

  describe "#result_type" do
    context "when the result is a RenewingRegistration" do
      let(:result) { build(:renewing_registration) }

      it "returns :renewal" do
        expect(helper.result_type(result)).to eq(:renewal)
      end
    end

    context "when the result is not a RenewingRegistration" do
      let(:result) { build(:registration) }

      context "when the result is pending" do
        before { result.metaData.status = "PENDING" }

        it "returns :new_registraton" do
          expect(helper.result_type(result)).to eq(:new_registration)
        end
      end

      context "when the result is not pending" do
        it "returns nil" do
          expect(helper.result_type(result)).to be_nil
        end
      end
    end
  end

  describe "#result_date" do
    context "when the result is inactive, refused or revoked" do
      before { result.metaData.status = %w[INACTIVE REFUSED REVOKED].sample }

      it "returns nil" do
        expect(helper.result_date(result)).to be_nil
      end
    end

    context "when the result is expired" do
      before { result.metaData.status = "EXPIRED" }

      it "returns the expected text" do
        date = result.expires_on.strftime("%d/%m/%Y")
        expect(helper.result_date(result)).to eq("Expired #{date}")
      end
    end

    context "when the result is active" do
      context "when the result is a registration" do
        let(:result) { build(:registration, :expires_soon) }

        it "returns the expected text" do
          date = result.expires_on.strftime("%d/%m/%Y")
          expect(helper.result_date(result)).to eq("Expires #{date}")
        end

        context "when the result has no expire date" do
          it "returns nil" do
            result.expires_on = nil

            expect(helper.result_date(result)).to be_nil
          end
        end
      end

      context "when the result is a transient_registration" do
        let(:result) { build(:renewing_registration) }

        it "returns the expected text" do
          date = Time.zone.today.strftime("%d/%m/%Y")
          expect(helper.result_date(result)).to eq("Updated #{date}")
        end
      end
    end
  end
end
