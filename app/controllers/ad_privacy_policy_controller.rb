# frozen_string_literal: true

class AdPrivacyPolicyController < ApplicationController
  include WasteCarriersEngine::Engine.routes.url_helpers

  before_action :authenticate_user!
  before_action :check_service_closure

  def show
    data_model = AdPrivacyPolicyData.new(params[:reg_identifier], params[:token])

    @presenter = AdPrivacyPolicyPresenter.new(data_model, view_context)
  end

  # We want to make use of our WasteCarriersEngine::BasePresenter because of the
  # complexity in determining where to go when the continue button is clicked.
  # But we don't have a 'model' which is what our BasePresenter expects. So we
  # use a Struct in its place as a means of passing our params to the presenter,
  # whilst still supporting the behaviour of delegating attribute calls to the
  # underlying 'model'.
  AdPrivacyPolicyData = Struct.new(:reg_identifier, :token)

  private

  def check_service_closure
    return unless WasteCarriersEngine::FeatureToggle.active?(:service_closure)

    redirect_to page_path("service_closed")
  end
end
