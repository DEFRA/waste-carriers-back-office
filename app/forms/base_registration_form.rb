# frozen_string_literal: true

class BaseRegistrationForm
  include ActiveModel::Model
  include WasteCarriersEngine::CanStripWhitespace

  extend ActiveModel::Callbacks

  attr_reader :transient_registration

  delegate :reg_identifier, to: :transient_registration

  validates(
    :reg_identifier,
    "waste_carriers_engine/reg_identifier": true,
    if: -> { transient_registration&.persisted? }
  )

  validate :transient_registration_valid?

  define_model_callbacks :initialize

  # The standard behaviour for loading a form is to check whether the requested form matches the workflow_state for
  # the registration, and redirect to the saved workflow_state if it doesn't.
  # But if the workflow state is 'flexible', we skip the check and load the requested form instead of the saved one.
  # This means users can still navigate by using the browser back button and reload forms which don't match the
  # saved workflow_state. We then update the workflow_state to match their request, rather than the other way around.
  # These are generally forms after 'start_form' but before 'declaration_form'.
  # Any form objects including this concern are considered to be 'flexible' by the FormsController.
  def self.can_navigate_flexibly?
    # This can be overriden in a subclass if one requires the avoidance of flexible navigation.
    true
  end

  def initialize(transient_registration)
    run_callbacks :initialize do
      # Get values from transient registration so form will be pre-filled
      @transient_registration = transient_registration
    end
  end

  def submit(attributes)
    attributes = strip_whitespace(attributes)

    transient_registration.assign_attributes(attributes)

    return transient_registration.save! if valid?

    false
  end

  private

  def transient_registration_valid?
    return if transient_registration.valid?

    transient_registration.errors.each do |_attribute, message|
      errors[:base] << message
    end
  end
end
