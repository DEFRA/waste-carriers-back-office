# frozen_string_literal: true

module Exceptions
  class MissingContactEmailError < StandardError
    def initialize(reg_identifier)
      super("Registration #{reg_identifier} has no contact email. Cannot send mail.")
    end
  end
end
