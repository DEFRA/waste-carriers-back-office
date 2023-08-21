# frozen_string_literal: true

# Adapted from: https://thoughtbot.com/blog/test-rake-tasks-like-a-boss
# and https://stackoverflow.com/a/42172531
#
# In the Thoughbot article it has custom method
# `loaded_files_excluding_current_rake_file` which is called in a `before`
# block. The purpose of this is to handle situations where you have more than
# one test of a rake file, which due to rake's idiosyncrasies can cause
# problems.
#
# However its inclusion leads to an issue where if a rake file contains more
# than one task and we have have a test for each, the last to be run will
# overwrite the results of the first in simplecov.
#
# So we have dropped its use and incorporated the notes from the stackoverflow
# article to cater for this situation, and ensure our test coverage is accurate.
#
# See also spec/support/rake_env.rb
require "rake"

# rubocop:disable RSpec/ContextWording
RSpec.shared_context "rake" do
  subject(:task) { Rake.application[task_name] }

  let(:task_name) { self.class.description }

  # `task_name` retrieves the description of the top-level `describe` block.
  # It iterates up the RSpec metadata chain, moving from the current context or example
  # to its parent (if present), until it reaches the outermost `describe` block.
  # This is so that we can get the task name based on the describe block rather
  # than it failing if we are at any deeper level such as context blocks in the test.
  let(:task_name) do
    current_metadata = self.class.metadata
    current_metadata = current_metadata[:parent_example_group] while current_metadata[:parent_example_group]
    current_metadata[:description]
  end

  let(:task_path) { "lib/tasks/#{task_name.split(':').first}" }
end
# rubocop:enable RSpec/ContextWording
