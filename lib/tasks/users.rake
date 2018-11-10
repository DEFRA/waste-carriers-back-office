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
      role = determine_admin_role(user_collections[:roles], user)
      if bo_user.nil?
        result = create_back_office_user(user_collections[:back_office], user, role)
        puts "Created new user: #{user[:email]}, #{role}" if result
        puts "Error creating new user: #{user[:email]}, #{role}" unless result
      elsif role != bo_user[:role]
        result = update_role(user_collections[:back_office], bo_user, role)
        puts "Updated #{user[:email]} to new role #{role}" if result
        puts "Error updating #{user[:email]} to new role #{role}" unless result
      else
        puts "No changes so skipping #{bo_user['email']}"
      end
    end
  end

  def back_office_user(collection, email)
    collection.find(email: email).first
  end

  def create_back_office_user(collection, user, role)
    result = collection.insert_one(
      email: user["email"],
      encrypted_password: user["encrypted_password"],
      sign_in_count: 0,
      failed_attempts: 0,
      role: role,
      confirmed_at: Time.now
    )
    return true if result.n.positive?

    false
  end

  def update_role(collection, user, new_role)
    result = collection.find(_id: user[:_id]).update_one("$set": { role: new_role })
    return true if result.n.positive?

    false
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
