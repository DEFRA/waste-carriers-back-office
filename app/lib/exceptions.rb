# frozen_string_literal: true

module Exceptions
  class AssistedDigitalContactEmailError < StandardError
    def initialize(reg_identifier)
      super("Registration #{reg_identifier} contact email matches the assisted digital one. Sending is blocked.")
    end
  end

  class MissingContactEmailError < StandardError
    def initialize(reg_identifier)
      super("Registration #{reg_identifier} has no contact email. Cannot send mail.")
    end
  end

  class AssistedDigitalLetterError < StandardError
    def initialize(reg_identifier)
      super("Registration #{reg_identifier} contact email should be the assisted digital one. Sending is blocked.")
    end
  end
end
