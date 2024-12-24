# frozen_string_literal: true

module SwissQRBill
  class QRBill < Data.define(:header, :creditor_information, :creditor, :ulimate_creditor, :debtor, :payment_amount_information, :payment_reference, :trailer, :additional_information, :raw) # rubocop:disable Style/DataInheritance
    Header = Data.define(:qr_type, :version, :coding_type)
    CreditorInformation = Data.define(:iban)
    PaymentReference = Data.define(:type, :reference, :additional_information)
    Trailer = Data.define(:trailer)

    PaymentAmountInformation = Data.define(:amount, :currency) do
      def initialize(amount:, currency:)
        super(amount: amount.to_f, currency:)
      end
    end

    CombinedAddress = Data.define(:type, :name, :line1, :line2, :country) do
      def street = line1
      def building_number = line1
      def postal_code = line2
      def town = line2
    end

    StructuredAddress = Data.define(:type, :name, :street, :building_number, :postal_code, :town, :country) do
      def line1 = "#{street} #{building_number}"
      def line2 = "#{postal_code} #{town}"
    end

    class Address
      def self.new(*data)
        case data[0]
        when "K"
          CombinedAddress.new(
            type: data[0],
            name: data[1],
            line1: data[2],
            line2: data[3],
            country: data[6]
          )
        when "S"
          StructuredAddress.new(*data)
        else
          raise %(Unknown Address type: "#{data[0]}") unless data.map(&:empty?).reduce(:&)

          StructuredAddress.new(*data)
        end
      end
    end

    AdditionalInformation = Data.define(:billing_information, :av1, :av2) do
      def initialize(billing_information: nil, av1: nil, av2: nil)
        super
      end
    end

    REGIONS = {
      00..02 => [:header, Header],
      03..03 => [:creditor_information, CreditorInformation],
      04..10 => [:creditor, Address],
      11..17 => [:ulimate_creditor, Address],
      18..19 => [:payment_amount_information, PaymentAmountInformation],
      20..26 => [:debtor, Address],
      27..29 => [:payment_reference, PaymentReference],
      30..30 => [:trailer, Trailer],
      31..33 => [:additional_information, AdditionalInformation]
    }.freeze

    def to_raw_data
      [
        header,
        creditor_information,
        creditor,
        ulimate_creditor,
        payment_amount_information,
        debtor,
        payment_reference,
        trailer,
        additional_information
      ].flat_map(&:deconstruct).map(&:to_s)
    end

    def to_s
      to_raw_data.join("\n")
    end
  end
end
