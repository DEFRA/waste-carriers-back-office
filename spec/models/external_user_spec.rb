# frozen_string_literal: true

require "cancan/matchers"
require "rails_helper"

RSpec.describe ExternalUser do
  it_behaves_like "a user", :external_user
end
