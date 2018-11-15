# frozen_string_literal: true

class UserMigrationService
  attr_reader :results

  def initialize
    @roles = BackendUsers::Role.all
    @backend_admins = BackendUsers::Admin.all
    @backend_agency_users = BackendUsers::AgencyUser.all
    @back_office_users = User.all

    @results = []
  end

  def sync
    sync_admin
    sync_agency
  end

  private

  def sync_admin
    @backend_admins.each do |user|
      bo_user = back_office_user(user[:email])
      role = determine_admin_role(user)
      sync_user(user, bo_user, role)
    end
  end

  def sync_agency
    @backend_agency_users.each do |user|
      bo_user = back_office_user(user[:email])
      role = determine_agency_role(user, bo_user)
      sync_user(user, bo_user, role)
    end
  end

  def sync_user(user, bo_user, backend_role)
    if bo_user.nil?
      create_user(user, backend_role)
    elsif role_has_changed?(bo_user, backend_role)
      update_role(bo_user, backend_role)
    else
      add_result(user[:email], backend_role, :skip)
    end
  end

  def back_office_user(email)
    @back_office_users.where(email: email).first
  end

  def create_user(user, role)
    result = User.collection.insert_one(
      email: user.email,
      encrypted_password: user.encrypted_password,
      sign_in_count: 0,
      failed_attempts: 0,
      role: role,
      confirmed_at: Time.now
    )
    action = result.n.positive? ? :create : :error
    add_result(user[:email], role, action)
  end

  def update_role(user, new_role)
    result = user.set(role: new_role)

    action = result.present? ? :update : :error
    add_result(user[:email], new_role, action)
  end

  def determine_admin_role(user)
    return "agency_super" unless user["role_ids"]

    determine_role(user)
  end

  def determine_agency_role(user, bo_user)
    # Because we are syncing across from the backend, we have to deal with
    # the fact that they have individuals who have both an admin and agency
    # user (because in the backend system admins can only manage users, not
    # actually do anything with registrations).
    # So when syncing agency users, if the role found in the back office is
    # an admin role, we leave it as is rather than overwriting it (in the
    # back office admins can do pretty much anything hence only one user
    # needed)
    return bo_user[:role] if bo_user && admin_role?(bo_user[:role])
    return "agency" unless user[:role_ids]

    determine_role(user)
  end

  def determine_role(user)
    role = @roles.where(_id: user[:role_ids][0]).first
    convert_role(role[:name])
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

  def role_has_changed?(bo_user, backend_role)
    bo_user[:role] != backend_role
  end

  def admin_role?(role)
    %w[agency_super finance_super].include?(role)
  end

  def add_result(email, role, action)
    @results << { email: email, role: role, action: action }
  end
end
