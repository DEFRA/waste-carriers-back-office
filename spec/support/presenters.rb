# frozen_string_literal: true

RSpec.configure do |config|
  # Adding this resolves getting the following error when you attemp to run the
  # presenter specs
  # NoMethodError:
  #    undefined method `setup' for RSpec::ExampleGroups::WasteCarriersEngineRegistrationPresenter:Class
  config.include RSpec::Rails::RailsExampleGroup, file_path: %r{spec/presenters}

  # Adding this gives us access to the view context and all its helpers in our
  # presenter specs, and means we don't have to include this behaviour in each
  # of them
  config.include ActionView::TestCase::Behavior, file_path: %r{spec/presenters}
end
