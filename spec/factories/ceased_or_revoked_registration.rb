# frozen_string_literal: true

FactoryBot.define do
  factory :ceased_or_revoked_registration, class: "CeasedOrRevokedRegistration" do
    initialize_with do
      new(reg_identifier: create(:registration, :active).reg_identifier,
          metaData: build(:metaData, status: "REVOKED"))
    end
  end
end
