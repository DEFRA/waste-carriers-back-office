# frozen_string_literal: true

module Reports
  class GenerateBoxiFilesService < ::WasteCarriersEngine::BaseService
    REGISTRATION_SERIALIZERS = [
      Boxi::AddressesSerializer,
      Boxi::KeyPeopleSerializer,
      Boxi::PaymentsSerializer,
      Boxi::RegistrationsSerializer,
      Boxi::SignOffsSerializer
    ].freeze

    # Given that orders have to have the same UID on all files, the public interface of these serializers is
    # a bit different from registrations ones, as it accepts an order_id as a parameter for serialization.
    # This allow us to keep the UID responsibility within this service.
    ORDER_SERIALIZERS = [
      Boxi::OrderItemsSerializer,
      Boxi::OrdersSerializer
    ].freeze

    THROTTLE_EVERY = 25
    THROTTLE_SLEEP = 0.010 # 10ms

    attr_reader :dir_path

    def run(dir_path)
      @dir_path = dir_path
      @order_uid = 1

      process_registrations

      registration_serializers.each(&:close)
      order_serializers.each(&:close)
    end

    private

    def process_registrations
      registrations.each.with_index do |registration, index|
        sleep(THROTTLE_SLEEP) if (index % THROTTLE_EVERY).zero?

        # Start counting from 1 rather than from 0
        uid = index + 1

        registration_serializers.each do |serializer|
          serializer.add_entries_for(registration, uid)
        end

        next unless registration.finance_details&.orders&.any?

        process_orders(registration, uid)
      end
    end

    def process_orders(registration, uid)
      registration.finance_details.orders.each do |order|
        order_serializers.each do |serializer|
          serializer.add_entries_for(order, uid, @order_uid)
        end

        @order_uid += 1
      end
    end

    def registrations
      @registrations ||= WasteCarriersEngine::Registration.all.no_timeout
    end

    def registration_serializers
      @registration_serializers ||= REGISTRATION_SERIALIZERS.map do |serializer_class|
        serializer_class.new(dir_path)
      end
    end

    def order_serializers
      @_order_serializers ||= ORDER_SERIALIZERS.map do |serializer_class|
        serializer_class.new(dir_path)
      end
    end
  end
end
