# frozen_string_literal: true

require "rails_helper"

RSpec.describe CardOrdersExportLog, type: :model do
  let(:export_filename) { Faker::File.file_name }
  let(:start_time) { Faker::Date.in_date_period.midnight }
  let(:end_time) { start_time + 1.week }
  let(:exported_at) { end_time + 30.hours }

  subject { described_class.new(start_time, end_time, export_filename, exported_at) }

  describe "#initialize" do
    it "records the time of the export" do
      expect(subject.exported_at).to eq exported_at
    end

    it "records the export filename" do
      expect(subject.export_filename).to eq export_filename
    end

    it "records the reporting window start and end time" do
      expect(subject.start_time).to eq start_time
      expect(subject.end_time).to eq end_time
    end
  end

  describe "#visit_download_link" do
    let(:user) { build(:user) }

    context "first visit" do
      it "records the first visit user" do
        expect { subject.visit_download_link(user) }.to change { subject.first_visited_by }.from(nil).to(user.id)
      end
      it "records the time of the first visit" do
        expect { subject.visit_download_link(user) }.to change { subject.first_visited_at }.from(nil)
        expect(subject.first_visited_at).to be_within(1.second).of(DateTime.now)
      end
    end

    context "second visit" do
      let(:first_user) { build(:user) }

      before { subject.visit_download_link(first_user) }

      it "does not update the first visit user" do
        expect { subject.visit_download_link(user) }.not_to change { subject.first_visited_by }.from(first_user.id)
      end
      it "does not update the time of the first visit" do
        expect { subject.visit_download_link(user) }.not_to change { subject.first_visited_at }
      end
    end
  end

end
