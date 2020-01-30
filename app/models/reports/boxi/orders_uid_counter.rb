# frozen_string_literal: true

# When generating boxi exports, we want to make sure we give all orders an unique ID that is not dependant on the
# registration those orders are part of. Hence this class is used in order to in crement the OrderId in isolation.
module Reports
  module Boxi
    class OrdersUidCounter
      @@count = 1

      def self.current_count
        @@count
      end

      def self.reset
        @@count = 1
      end

      def self.increment
        @@count += 1
      end
    end
  end
end
