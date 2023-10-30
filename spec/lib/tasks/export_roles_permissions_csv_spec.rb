# frozen_string_literal: true

require "rails_helper"

RSpec.describe "debug:export_roles_permissions", type: :rake do
  subject(:rake_task) { Rake::Task["debug:export_roles_permissions"] }

  include_context "rake"

  it { expect { rake_task.invoke }.not_to raise_error }
end
