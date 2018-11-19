# frozen_string_literal: true

FactoryBot.define do
  factory :role, class: BackendUsers::Role do
    trait :agency_with_refund do
      name { "Role_agencyRefundPayment" }
      resource_type { "AgencyUser" }
    end

    trait :finance do
      name { "Role_financeBasic" }
      resource_type { "AgencyUser" }
    end

    trait :finance_admin do
      name { "Role_financeAdmin" }
      resource_type { "AgencyUser" }
    end

    trait :finance_super do
      name { "Role_financeSuper" }
      resource_type { "Admin" }
    end
  end
end
