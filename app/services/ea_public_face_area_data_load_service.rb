# frozen_string_literal: true

require "zip"

# Loads the EA public face area boundaries GeoJSON into MongoDB for the
# engine's geospatial EA area lookup. The fixture uses British National Grid
# coordinates; MongoDB needs WGS84, so each vertex is converted on load.
class EaPublicFaceAreaDataLoadService < WasteCarriersEngine::BaseService
  AREAS_FILENAME = "Administrative_Boundaries_Environment_Agency_and_Natural_England_Public_Face_Areas.geojson"

  def run
    features = JSON.parse(read_areas_file).fetch("features")
    results = features.filter_map { |feature| process_feature(feature) }

    WasteCarriersEngine::EaPublicFaceArea.create_indexes

    results
  end

  private

  def process_feature(feature)
    properties = feature["properties"]
    return if properties["seaward"] == "Yes"

    area = WasteCarriersEngine::EaPublicFaceArea.find_or_initialize_by(code: properties["code"])
    action = area.new_record? ? "created" : "updated"

    area.update(
      name: properties["long_name"],
      area_id: properties["identifier"],
      area: convert_geometry(feature["geometry"])
    )

    { action:, code: area.code, name: area.name }
  end

  def convert_geometry(geometry)
    { "type" => geometry["type"], "coordinates" => convert_coordinates(geometry["coordinates"]) }
  end

  def convert_coordinates(value)
    return value.map { |element| convert_coordinates(element) } unless value.first.is_a?(Numeric)

    point = WasteCarriersEngine::ConvertEastingNorthingToLatLonService.run(easting: value[0], northing: value[1])
    [point[:longitude], point[:latitude]]
  end

  def read_areas_file
    Zip::File.open(Rails.root.join("lib/fixtures/#{AREAS_FILENAME}.zip")) do |zip_file|
      zip_file.glob(AREAS_FILENAME).first.get_input_stream.read
    end
  end
end
