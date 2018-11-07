# frozen_string_literal: true

module TimeHelpers
  # https://stackoverflow.com/a/4136485/6117745
  def self.humanise(seconds)
    [[60, :seconds], [60, :minutes], [24, :hours], [1000, :days]].map do |count, name|
      if seconds.positive?
        seconds, n = seconds.divmod(count)
        "#{n.to_i} #{name}"
      end
    end.compact.reverse.join(" ")
  end
end
