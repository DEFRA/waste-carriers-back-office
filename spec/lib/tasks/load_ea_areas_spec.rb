# frozen_string_literal: true

require "rails_helper"

RSpec.describe "load_ea_areas", type: :task do
  subject(:rake_task) { Rake::Task["load_ea_areas"] }

  include_context "rake"

  let(:results) { [{ action: "created", code: "WSX", name: "Wessex" }] }

  before do
    rake_task.reenable
    allow(EaPublicFaceAreaDataLoadService).to receive(:run).and_return(results)
  end

  it "runs the data load service" do
    rake_task.invoke

    expect(EaPublicFaceAreaDataLoadService).to have_received(:run)
  end

  context "when run outside the test environment" do
    before { allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new("development")) }

    it "reports each area loaded" do
      expect { rake_task.invoke }.to output(/Created EA public face area "WSX" \(Wessex\)/).to_stdout
    end
  end

  context "when the load fails" do
    before { allow(EaPublicFaceAreaDataLoadService).to receive(:run).and_raise(StandardError, "no such file") }

    it "reports the error" do
      expect { rake_task.invoke }.to output(/Error loading EA public face areas: no such file/).to_stdout
    end
  end
end
