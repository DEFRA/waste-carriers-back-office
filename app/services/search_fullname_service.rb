# frozen_string_literal: true

class SearchFullnameService < ::WasteCarriersEngine::BaseService
  def run(page:, term:)
    return response_hash([]) if term.blank?

    @page = page
    @term = term.strip

    response_hash(search_results)
  end

  private

  def response_hash(results)
    {
      count: results.count,
      results: Kaminari.paginate_array(results).page(@page)
    }
  end

  def search_results
    @_search_results ||= matching_resources.sort_by do |resource|
      resource.reg_identifier || ""
    end
  end

  def matching_resources
    search(WasteCarriersEngine::Registration) +
      search(WasteCarriersEngine::TransientRegistration)
  end

  def search(model)
    search_registered_name(model) + search_key_people(model)
  end

  def search_registered_name(model)
    run_search_for_pipeline(
      model,
      [
        # Project an additional fullname field and then match against it.
        { "$addFields": { fullname:
          { "$toLower": { "$concat": ["$firstName", " ", "$lastName"] } } } },
        { "$match": { fullname: @term.downcase } },
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
        # ... then project an additional key_fullname field to match against.
        { "$addFields": { key_fullname:
          { "$toLower": { "$concat": ["$key_person.first_name", " ", "$key_person.last_name"] } } } },
        { "$match": { key_fullname: @term.downcase } },
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
    end
  end
end
