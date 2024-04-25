# frozen_string_literal: true

require "rails_helper"

RSpec.describe "fix missing conviction signoffs", type: :task do
  describe "one_off:fix_missing_conviction_signoffs" do
    let(:task) { Rake::Task["one_off:fix_missing_conviction_signoffs"] }
    let(:conviction_search_result) { build(:conviction_search_result, :match_result_no) }
    let(:key_people) { build_list(:key_person, 2, conviction_search_result:) }

    include_context "rake"

    before { task.reenable }

    shared_examples "does not add a conviction signoff" do
      it { expect { task.invoke }.not_to change { registration.reload.conviction_sign_offs } }
    end

    shared_examples "adds a conviction signoff" do
      it { expect { task.invoke }.to change { registration.reload.conviction_sign_offs } }

      it "is matched for display on the dashboard" do
        expect(WasteCarriersEngine::Registration.convictions_possible_match).not_to include(registration)

        task.invoke

        expect(WasteCarriersEngine::Registration.convictions_possible_match).to include(registration)
      end
    end

    it { expect { task.invoke }.not_to raise_error }

    context "when a registration has a conviction_sign_off" do

      let!(:registration) do # rubocop:disable RSpec/LetSetup
        create(:registration, key_people:, conviction_sign_offs: [build(:conviction_sign_off)])
      end

      it_behaves_like "does not add a conviction signoff"
    end

    context "when a registration does not have a conviction sign off" do

      let!(:registration) do
        create(:registration, key_people:, conviction_sign_offs: [])
      end

      context "when all key people have a conviction search result of \"NO\"" do
        let(:match_result) { :match_result_no }

        it_behaves_like "does not add a conviction signoff"
      end

      context "when a key person has a conviction search result of \"YES\"" do
        before { registration.key_people.last.conviction_search_result.update(match_result: "YES") }

        it_behaves_like "adds a conviction signoff"
      end

      # limit the scope to the time after this issue manifested in production
      context "when the registration was last updated before March 2023" do
        before { registration.metaData.update(last_modified: DateTime.parse("2024-02-29")) }

        it_behaves_like "does not add a conviction signoff"
      end
    end
  end
end
