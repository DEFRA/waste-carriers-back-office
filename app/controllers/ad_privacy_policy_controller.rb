# frozen_string_literal: true

class AdPrivacyPolicyController < ApplicationController
  before_action :authenticate_user!

  def show
    data_model = AdPrivacyPolicyData.new(params[:reg_identifier], params[:token])

    @presenter = AdPrivacyPolicyPresenter.new(data_model, view_context)
  end

  private

  # We want to make use of our WasteCarriersEngine::BasePresenter because of the
  # complexity in determining where to go when the continue button is clicked.
  # But we don't have a 'model' which is what our BasePresenter expects. So we
  # use a Struct in its place as a means of passing our params to the presenter,
  # whilst still supporting the behaviour of delegating attribute calls to the
  # underlying 'model'.
  AdPrivacyPolicyData = Struct.new(:reg_identifier, :token)

end
