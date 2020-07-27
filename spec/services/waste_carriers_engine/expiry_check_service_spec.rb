# frozen_string_literal: true

require "rails_helper"

module WasteCarriersEngine
  RSpec.describe ExpiryCheckService do
    # Registration is made during British Summer Time (BST)
    # UK local time is 00:30 on 28 March 2017
    # UTC time is 23:30 on 27 March 2017
    # Registration should expire on 28 March 2020
    let!(:bst_registration) do
      registration = create(:registration)
      registration.metaData.status = "EXPIRED"
      registration.metaData.date_registered = Time.find_zone("London").local(2017, 3, 28, 0, 30)
      registration.expires_on = registration.metaData.date_registered + 3.years
      registration.save!
      registration
    end

    # Registration is made in during Greenwich Mean Time (GMT)
    # UK local time & UTC are both 23:30 on 27 October 2015
    # Registration should expire on 27 October 2018
    let!(:gmt_registration) do
      registration = build(:registration)
      registration.metaData.status = "EXPIRED"
      registration.metaData.date_registered = Time.find_zone("London").local(2015, 10, 27, 23, 30)
      registration.expires_on = registration.metaData.date_registered + 3.years
      registration.save!
      registration
    end

    describe "#in_expiry_grace_window?" do
      # You have to use let! to ensure it is not lazy-evaluated. If it is
      # it will be called inside the Timecop.freeze methods listed below
      # which means Date.today will evaluate to the date Timecop is freezing.
      # This leads to false positives for some tests, and a fail for the outside
      # renewal window.
      let!(:registration) { build(:registration, expires_on: Date.today) }
      subject { ExpiryCheckService.new(registration) }

      context "when use_extended_grace_window is true" do
        before { expect(FeatureToggle).to receive(:active?).with(:use_extended_grace_window).and_return(true) }

        context "and the current date is less than 3 years after expiry" do
          it "returns true" do
            Timecop.freeze(Date.today + 2.years) do
              expect(subject.in_expiry_grace_window?).to eq(true)
            end
          end
        end

        context "and the current date is more than 3 years after expiry" do
          it "returns false" do
            Timecop.freeze(Date.today + 3.years) do
              expect(subject.in_expiry_grace_window?).to eq(false)
            end
          end
        end

        context "and the current date is before expiry" do
          it "returns false" do
            Timecop.freeze(Date.today - 1.year) do
              expect(subject.in_expiry_grace_window?).to eq(false)
            end
          end
        end
      end

      context "when the grace window is 3 days" do
        before { allow(Rails.configuration).to receive(:grace_window).and_return(3) }

        context "and the current date is within the window" do
          it "returns true" do
            Timecop.freeze((Date.today + 3.days) - 1.day) do
              expect(subject.in_expiry_grace_window?).to eq(true)
            end
          end
        end

        context "and the current date is outside the window" do
          it "returns false" do
            Timecop.freeze(Date.today + 3.days) do
              expect(subject.in_expiry_grace_window?).to eq(false)
            end
          end
        end

        context "when the registration was created in BST and expires in GMT" do
          subject { ExpiryCheckService.new(bst_registration) }

          it "should not be within the grace window for an extra day due to the time difference" do
            # Skip ahead to the start of the day a reg should expire, plus the
            # grace window
            Timecop.freeze(Time.find_zone("London").local(2020, 3, 31, 0, 1)) do
              # GMT is now in effect (not BST)
              # UK local time & UTC are both 00:01 on 28 March 2020
              expect(subject.in_expiry_grace_window?).to eq(false)
            end
          end
        end

        context "when the registration was created in GMT and expires in BST" do
          subject { ExpiryCheckService.new(gmt_registration) }

          it "should not be within the grace window for an extra day due to the time difference" do
            # Skip ahead to the start of the day a reg should expire, plus the
            # grace window
            Timecop.freeze(Time.find_zone("London").local(2018, 10, 30, 0, 1)) do
              # BST is now in effect (not GMT)
              # UK local time is 00:01 on 27 October 2018
              # UTC time is 23:01 on 26 October 2018
              expect(subject.in_expiry_grace_window?).to eq(false)
            end
          end
        end
      end

      context "when there is no grace window" do
        before { allow(Rails.configuration).to receive(:grace_window).and_return(0) }

        it "returns false" do
          Timecop.freeze(Date.today + 3.days) do
            expect(subject.in_expiry_grace_window?).to eq(false)
          end
        end
      end
    end

    describe "#in_standard_expiry_grace_window?" do
      # You have to use let! to ensure it is not lazy-evaluated. If it is
      # it will be called inside the Timecop.freeze methods listed below
      # which means Date.today will evaluate to the date Timecop is freezing.
      # This leads to false positives for some tests, and a fail for the outside
      # renewal window.
      let!(:registration) { build(:registration, expires_on: Date.today) }
      subject { ExpiryCheckService.new(registration) }

      context "when the grace window is 3 days" do
        before { allow(Rails.configuration).to receive(:grace_window).and_return(3) }

        context "and the current date is within the window" do
          it "returns true" do
            Timecop.freeze((Date.today + 3.days) - 1.day) do
              expect(subject.in_standard_expiry_grace_window?).to eq(true)
            end
          end
        end

        context "and the current date is outside the window" do
          it "returns false" do
            Timecop.freeze(Date.today + 3.days) do
              expect(subject.in_standard_expiry_grace_window?).to eq(false)
            end
          end
        end

        context "when the registration was created in BST and expires in GMT" do
          subject { ExpiryCheckService.new(bst_registration) }

          it "should not be within the grace window for an extra day due to the time difference" do
            # Skip ahead to the start of the day a reg should expire, plus the
            # grace window
            Timecop.freeze(Time.find_zone("London").local(2020, 3, 31, 0, 1)) do
              # GMT is now in effect (not BST)
              # UK local time & UTC are both 00:01 on 28 March 2020
              expect(subject.in_standard_expiry_grace_window?).to eq(false)
            end
          end
        end

        context "when the registration was created in GMT and expires in BST" do
          subject { ExpiryCheckService.new(gmt_registration) }

          it "should not be within the grace window for an extra day due to the time difference" do
            # Skip ahead to the start of the day a reg should expire, plus the
            # grace window
            Timecop.freeze(Time.find_zone("London").local(2018, 10, 30, 0, 1)) do
              # BST is now in effect (not GMT)
              # UK local time is 00:01 on 27 October 2018
              # UTC time is 23:01 on 26 October 2018
              expect(subject.in_standard_expiry_grace_window?).to eq(false)
            end
          end
        end
      end
    end
  end
end
