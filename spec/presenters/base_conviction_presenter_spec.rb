# frozen_string_literal: true

require "rails_helper"

RSpec.describe BaseConvictionPresenter do
  let(:registration) { double(:registration) }
  let(:view_context) { double(:view_context) }
  subject { described_class.new(registration, view_context) }
end
