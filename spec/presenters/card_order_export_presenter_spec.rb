# frozen_string_literal: true

require "rails_helper"

RSpec.describe CardOrderExportPresenter do
  subject { described_class.new(card_orders_export_log) }

  let(:card_orders_export_log) { create(:card_orders_export_log) }

  describe "#exported_at" do
    it "presents the export time in the correct format" do
      expect(subject.exported_at).to eq card_orders_export_log.exported_at.strftime("%Y-%m-%d %H:%M")
      expect(subject.exported_at).to match(/\d{4}-\d{2}-\d{2} \d{2}:\d{2}/)
    end
  end

  describe "#first_downloaded_by" do
    context "with an unvisited download link" do
      it "returns nil" do
        expect(subject.first_downloaded_by).to be_nil
      end
    end

    context "with a visited download link" do
      let(:user) { create(:user) }

      before { card_orders_export_log.visit_download_link(user) }

      it "returns the user's email address" do
        expect(subject.first_downloaded_by).to eq user.email
      end
    end
  end

  describe "#first_downloaded_at" do
    context "with an unvisited download link" do
      it "returns nil" do
        expect(subject.first_downloaded_at).to be_nil
      end
    end

    context "with a visited download link" do
      let(:user) { create(:user) }

      before { card_orders_export_log.visit_download_link(user) }

      it "returns the link visit time in the correct format" do
        expect(subject.first_downloaded_at).to eq card_orders_export_log.first_visited_at.strftime("%Y-%m-%d %H:%M")
        expect(subject.first_downloaded_at).to match(/\d{4}-\d{2}-\d{2} \d{2}:\d{2}/)
      end
    end
  end
end
