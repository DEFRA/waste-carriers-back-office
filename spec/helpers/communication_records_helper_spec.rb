# frozen_string_literal: true

require "rails_helper"

RSpec.describe CommunicationRecordsHelper do
  describe "#notify_content_html" do
    subject(:html) { helper.notify_content_html(content) }

    context "with blank content" do
      let(:content) { nil }

      it { expect(html).to be_nil }
    end

    context "with Notify markdown content" do
      let(:content) do
        "Dear Jane Doe,\r\n\r\n" \
          "#Please pay for your registration\r\n" \
          "You need to include:\r\n" \
          "*your registration number\r\n" \
          "*the amount you paid\r\n\r\n" \
          "[Renew online](https://example.gov.uk/renew)"
      end

      it "renders paragraphs with GOV.UK classes" do
        expect(html).to include('<p class="govuk-body-m">Dear Jane Doe,</p>')
      end

      it "demotes headings so the page keeps a single h1" do
        expect(html).to include('<h2 class="govuk-heading-s">Please pay for your registration</h2>')
        expect(html).not_to include("<h1")
      end

      it "renders bullets without a space after the marker as a list" do
        expect(html).to include('<ul class="govuk-list govuk-list--bullet">')
        expect(html).to include("<li>your registration number</li>")
      end

      it "renders links with the govuk-link class" do
        expect(html).to include('<a href="https://example.gov.uk/renew" class="govuk-link">Renew online</a>')
      end
    end

    context "with HTML in the content" do
      let(:content) { "Dear <script>alert(1)</script> <b>Jane</b>," }

      it "strips markup that is not in the allowed list" do
        expect(html).not_to include("<script")
        expect(html).not_to include("<b>")
        expect(html).to include("Jane")
      end
    end
  end
end
