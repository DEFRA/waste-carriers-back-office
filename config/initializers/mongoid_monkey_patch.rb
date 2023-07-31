# frozen_string_literal: true

module Mongoid
  module Attributes
    module Processing
      prepend WasteCarriersEngine::MongoidMonkeyPatch
    end
  end
end
