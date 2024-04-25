# frozen_string_literal: true

require "rails_helper"

RSpec.describe "clearing invalid conviction signoffs", type: :task do
  describe "one_off:clear_invalid_conviction_signoffs" do
    let(:task) { Rake::Task["one_off:clear_invalid_conviction_signoffs"] }
    let(:conviction_sign_offs) { [build(:conviction_sign_off)] }
    let(:conviction_search_result) { build(:conviction_search_result, :match_result_no) }

    include_context "rake"

    before { task.reenable }

    shared_examples "does not remove the conviction signoff" do
      it { expect { task.invoke }.not_to change { registration.reload.conviction_sign_offs } }
    end

    it "runs without error" do
      expect { task.invoke }.not_to raise_error
    end

    context "when a registration has declared convictions" do
      let!(:registration) do # rubocop:disable RSpec/LetSetup
        create(:registration, conviction_search_result:,
                              declared_convictions: "yes",
                              conviction_sign_offs:)
      end

      it_behaves_like "does not remove the conviction signoff"
    end

    context "when a registration has a potential conviction match" do
      let!(:registration) do # rubocop:disable RSpec/LetSetup
        create(:registration, :requires_conviction_check,
               conviction_search_result: build(:conviction_search_result, :match_result_yes),
               conviction_sign_offs:)
      end

      it_behaves_like "does not remove the conviction signoff"
    end

    context "when a registration has no declared convictions and no conviction matches" do
      let!(:registration) do
        create(:registration, conviction_search_result:,
                              conviction_sign_offs:)
      end

      it "removes the redundant conviction signoff" do
        expect { task.invoke }.to change { registration.reload.conviction_sign_offs.length }.by(-1)
      end

      context "when the registration has relevant key people" do
        before { registration.key_people.first.update(person_type: "RELEVANT") }

        it_behaves_like "does not remove the conviction signoff"
      end

      # limit the scope to the time after this issue manifested in production
      context "when the registration was last updated before March 2023" do
        before { registration.metaData.update(last_modified: DateTime.parse("2024-02-29")) }

        it_behaves_like "does not remove the conviction signoff"
      end
    end
  end

  describe "one_off:clear_transient_invalid_conviction_signoffs" do
    let(:task) { Rake::Task["one_off:clear_transient_invalid_conviction_signoffs"] }
    let(:conviction_sign_offs) { [build(:conviction_sign_off)] }
    let(:conviction_search_result) { build(:conviction_search_result, :match_result_no) }
    let(:key_people) { [build(:key_person, :does_not_require_conviction_check)] }

    include_context "rake"

    before { task.reenable }

    shared_examples "does not remove the conviction signoff" do
      it { expect { task.invoke }.not_to change { renewing_registration.reload.conviction_sign_offs } }
    end

    it "runs without error" do
      expect { task.invoke }.not_to raise_error
    end

    context "when a registration has declared convictions" do
      let!(:renewing_registration) do # rubocop:disable RSpec/LetSetup
        create(:renewing_registration,
               conviction_search_result:, declared_convictions: "yes", conviction_sign_offs:)
      end

      it_behaves_like "does not remove the conviction signoff"
    end

    context "when a registration has a potential conviction match" do
      let!(:renewing_registration) do # rubocop:disable RSpec/LetSetup
        create(:renewing_registration, :requires_conviction_check,
               conviction_search_result: build(:conviction_search_result, :match_result_yes),
               conviction_sign_offs:)
      end

      it_behaves_like "does not remove the conviction signoff"
    end

    context "when a registration has no declared convictions and no conviction matches" do
      let!(:renewing_registration) do
        create(:renewing_registration,
               conviction_search_result:,
               conviction_sign_offs:, key_people:)
      end

      it "removes the redundant conviction signoff" do
        expect { task.invoke }.to change { renewing_registration.reload.conviction_sign_offs.length }.by(-1)
      end

      context "when the registration has relevant key people" do
        before { renewing_registration.key_people.first.update(person_type: "RELEVANT") }

        it_behaves_like "does not remove the conviction signoff"
      end

      # limit the scope to the time after this issue manifested in production
      context "when the registration was last updated before March 2023" do
        before { renewing_registration.metaData.update(last_modified: DateTime.parse("2024-02-29")) }

        it_behaves_like "does not remove the conviction signoff"
      end
    end
  end
end
