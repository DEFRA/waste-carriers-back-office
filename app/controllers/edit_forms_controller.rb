# frozen_string_literal: true

class EditFormsController < WasteCarriersEngine::FormsController

  prepend_before_action :authenticate_user!

  def new
    super(EditForm, "edit_form")
  end

  def create
    super(EditForm, "edit_form")
  end

  def edit_cbd_type
    transition_to_edit("edit_cbd_type")
  end

  def edit_company_name
    transition_to_edit("edit_company_name")
  end

  def edit_main_people
    transition_to_edit("edit_main_people")
  end

  def edit_company_address
    transition_to_edit("edit_company_address")
  end

  def edit_contact_name
    transition_to_edit("edit_contact_name")
  end

  def edit_contact_phone
    transition_to_edit("edit_contact_phone")
  end

  def edit_contact_email
    transition_to_edit("edit_contact_email")
  end

  def edit_contact_address
    transition_to_edit("edit_contact_address")
  end

  def edit_location
    transition_to_edit("edit_location")
  end

  private

  # rubocop:disable Naming/MemoizedInstanceVariableName
  def find_or_initialize_transient_registration(token)
    @transient_registration ||= EditRegistration.where(reg_identifier: token).first ||
                                EditRegistration.where(token: token).first ||
                                EditRegistration.new(reg_identifier: token)
  end
  # rubocop:enable Naming/MemoizedInstanceVariableName

  def transition_to_edit(transition)
    find_or_initialize_transient_registration(params[:token])

    return unless setup_checks_pass?

    @transient_registration.send("#{transition}!".to_sym)
    redirect_to_correct_form
  end

  def fetch_presenters
    @presenter = EditFormPresenter.new(@edit_form, view_context)
  end
end
