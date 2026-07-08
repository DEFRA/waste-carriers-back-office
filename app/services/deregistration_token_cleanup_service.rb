# frozen_string_literal: true

# One-off data cleanup for the removed self-service deregistration feature.
# Legacy `registrations` documents still carry the obsolete deregistration_token
# and deregistration_token_created_at fields. The Registration model no longer
# declares them, so we unset them directly on the collection. Idempotent: a
# second run matches nothing.
class DeregistrationTokenCleanupService < WasteCarriersEngine::BaseService

  OBSOLETE_FIELDS = %w[deregistration_token deregistration_token_created_at].freeze

  def run
    selector = { "$or" => OBSOLETE_FIELDS.map { |field| { field => { "$exists" => true } } } }

    console_log "Removing #{OBSOLETE_FIELDS.join(', ')} from #{collection.count_documents(selector)} registrations"

    result = collection.update_many(selector, "$unset" => OBSOLETE_FIELDS.index_with { "" })

    console_log "Modified #{result.modified_count} registrations"
  end

  private

  def collection
    WasteCarriersEngine::Registration.collection
  end

  def console_log(text)
    # :nocov:
    puts text unless Rails.env.test? # rubocop:disable Rails/Output
    # :nocov:
  end

end
