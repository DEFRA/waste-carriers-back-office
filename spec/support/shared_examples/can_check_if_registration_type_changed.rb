# frozen_string_literal: true

RSpec.shared_examples "Can check if registration type changed" do
  describe "#registration_type_changed?" do
    context "when the resource is created" do
      it "returns false" do
        expect(subject.registration_type_changed?).to be false
      end

      context "when the registration_type is updated" do
        before do
          subject.registration_type = "broker_dealer"
        end

        it "returns true" do
          expect(subject.registration_type_changed?).to be true
        end
      end
    end
  end
end
