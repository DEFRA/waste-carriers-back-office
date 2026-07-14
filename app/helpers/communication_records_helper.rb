# frozen_string_literal: true

module CommunicationRecordsHelper
  NOTIFY_ALLOWED_TAGS = %w[p a ul ol li h2 h3 h4 h5 h6 blockquote hr br].freeze
  NOTIFY_ALLOWED_ATTRS = %w[href class].freeze

  # Render a Notify message body (Notify markdown) as GOV.UK Frontend HTML.
  def notify_content_html(content)
    return if content.blank?

    markdown = content.gsub(/^([*-])(?=[^\s*-])/, '\1 ') # Notify omits the space after bullet markers
    renderer = GovukMarkdown::Renderer.new({ headings_start_with: "s" }, { link_attributes: { class: "govuk-link" } })
    # lax_spacing: Notify omits the blank line before lists that Redcarpet needs
    html = Redcarpet::Markdown.new(renderer, tables: true, no_intra_emphasis: true, lax_spacing: true).render(markdown)

    # Demote headings one level (h1 -> h2, h2 -> h3) so the page keeps a single h1
    html = html.gsub(%r{<(/?)h2\b}, '<\1h3').gsub(%r{<(/?)h1\b}, '<\1h2')

    sanitize(html, tags: NOTIFY_ALLOWED_TAGS, attributes: NOTIFY_ALLOWED_ATTRS) # body carries personalisation
  end
end
