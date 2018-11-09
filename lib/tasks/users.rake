# frozen_string_literal: true

require "db"

namespace :users do
  desc "Sync backend users with back-office"
  task sync_internal_users: :environment do

    user_collections = {
      roles: Db.roles_collection,
      admin: Db.admin_users_collection,
      agency: Db.agency_users_collection,
      back_office: Db.back_office_users_collection
    }

    counts = Db.counts(user_collections[:admin])
    paging = Db.paging(counts[:total], 100)

    Db.paged_collection(paging, user_collections[:admin]).each do |user|
      bo_user = back_office_user(user_collections[:back_office], user["email"])
      begin
        if bo_user.nil?
          role = determine_admin_role(user_collections[:roles], user)
          create_back_office_user(user, role)
          puts "Created new back office user: #{user.email}, #{role}"
        else
          puts "Skipping admin #{bo_user['email']}"
        end
      rescue StandardError => ex
        puts ex
      end
    end
  end

  def back_office_user(collection, email)
    collection.find(email: email).first
  end

  def create_back_office_user(user, role)
    User.create(
      email: user["email"],
      role: role,
      password: user["encrypted_password"],
      confirmed_at: Time.now
    ).save!
  end

  def determine_admin_role(collection, user)
    return :agency_super unless user["role_ids"]

    role = collection.find(_id: user["role_ids"][0]).first
    convert_role(role["name"])
  end

  def convert_role(role)
    case role
    when "Role_financeSuper"
      new_role = "finance_super"
    when "Role_agencyRefundPayment"
      new_role = "agency_with_refund"
    when "Role_financeAdmin"
      new_role = "finance_admin"
    when "Role_financeBasic"
      new_role = "finance"
    end
    new_role
  end
end
