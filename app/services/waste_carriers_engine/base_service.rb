# frozen_string_literal: true

module WasteCarriersEngine
  class BaseService
    def self.run(attrs = nil)
      new.run(attrs)
    end
  end
end
