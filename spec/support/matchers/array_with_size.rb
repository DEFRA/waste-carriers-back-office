# frozen_string_literal: true

# spec/support/matchers/array_with_size.rb

RSpec::Matchers.define :array_with_size do |expected_size, expected_class|
  match do |actual|
    actual.is_a?(Array) && actual.size == expected_size

    if expected_class.present?
      actual.all? { |element| element.is_a?(expected_class) }
    else
      true
    end
  end

  failure_message do |actual|
    "expected an array with size #{expected_size}, but got #{actual.class} with size #{actual.size}"
  end
end
