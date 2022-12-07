# frozen_string_literal: true

class SearchFullnameService < BaseSearchService

  private

  def search(model)
    search_registered_name(model) + search_key_people(model)
  end

  def search_registered_name(model)
    run_search_for_pipeline(
      model,
      [
        # Preliminary filter on first name to reduce the amount of projecting needed
        { "$match": { "$expr": { "$eq": [{ "$indexOfCP": [@term, { "$toLower": "$firstName" }] }, 0] } } },
        # Project an additional fullname field and then match against it.
        { "$addFields": { fullname:
          { "$toLower": { "$concat": ["$firstName", " ", "$lastName"] } } } },
        { "$match": { fullname: @term } },
        { "$limit": 100 }
      ]
    )
  end

  def search_key_people(model)
    run_search_for_pipeline(
      model,
      [
        # Create a separate document for each key person...
        { "$addFields": { key_person: "$key_people" } },
        { "$unwind": "$key_person" },
        # Preliminary filter on first name to reduce the amount of projecting needed
        { "$match": { "$expr": { "$eq": [{ "$indexOfCP": [@term, { "$toLower": "$key_person.first_name" }] }, 0] } } },
        # ... then project an additional key_fullname field to match against.
        { "$addFields": { key_fullname:
          { "$toLower": { "$concat": ["$key_person.first_name", " ", "$key_person.last_name"] } } } },
        { "$match": { key_fullname: @term } },
        { "$limit": 100 }
      ]
    )
  end

  def run_search_for_pipeline(model, pipeline)
    matching_docs = model.collection.aggregate(pipeline, read: { mode: :secondary }).to_a

    bson_docs_to_models(matching_docs, model)
  end

  # Map the BSON documents returned by the pipeline to Rails models:
  def bson_docs_to_models(docs, model)
    docs.map do |doc|
      doc_model = if model == WasteCarriersEngine::Registration
                    model
                  else
                    # Both New and Renewing registrations are held in the TransientRegistration collection.
                    # Need to determine the specific model type in order to map the document to a model instance.
                    doc["_type"].constantize
                  end

      # Skip any other registration types, e.g.EditRegistraitons
      next unless [WasteCarriersEngine::Registration,
                   WasteCarriersEngine::NewRegistration,
                   WasteCarriersEngine::RenewingRegistration].include? doc_model

      doc_model.new(doc.except(:fullname, :key_person, :key_fullname)) { |m| m.new_record = false }
    end.compact
  end
end
