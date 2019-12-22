# frozen_string_literal: true

module Reports
  class GenerateBoxiFilesService < ::WasteCarriersEngine::BaseService
    ALL_SERIALIZERS = [
      Boxi::AddressesSerializer,
      Boxi::KeyPeopleSerializer,
      Boxi::OrderItemsSerializer,
      Boxi::OrdersSerializer,
      Boxi::PaymentsSerializer,
      Boxi::RegistrationsSerializer,
      Boxi::SignOffsSerializer
    ].freeze

    attr_reader :dir_path

    def run(dir_path)
      @dir_path = dir_path

      registrations.each.with_index do |registration, uid|
        serializers.each do |serializer|
          serializer.add_entries_for(registration, uid)
        end
      end

      serializers.each(&:close)
    end

    private

    def registrations
      @_registrations ||= WasteCarriersEngine::Registration.all
    end

    def serializers
      @_serializers ||= ALL_SERIALIZERS.map do |serializer_class|
        serializer_class.new(dir_path)
      end
    end
  end
end
