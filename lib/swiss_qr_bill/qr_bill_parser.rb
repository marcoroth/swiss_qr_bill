# frozen_string_literal: true

require "qr_code_scanner"

module SwissQRBill
  class QRBillParser
    def self.parse_file(path)
      detected_codes = QRCodeScanner.scan(path)

      return [] if detected_codes.empty?

      detected_codes.map { |code| parse(code) }
    end

    def self.parse(data)
      case data
      when String
        data = if data.count("\r").positive?
                 data.split("\r\n")
               else
                 data.split("\n")
               end
      when Array
        # ok
      else
        raise "Unsupported data argument type. Expected data argument of type Array or String, got: #{data.class}"
      end

      raise "Unsupported data length. Data object must have at least 31 entries. Found: #{data.length}" if data.length < 31
      raise "Unsupported QRType: #{data[0]}" if data[0] != "SPC"
      raise "Unsupported Version: #{data[1]}" if data[1] != "0200"
      raise "Unsupported Coding: #{data[2]}" if data[2] != "1"

      regions = QRBill::REGIONS.to_h { |range, (key, klass)| [key, klass.new(*data[range])] }

      QRBill.new(
        raw: data,
        **regions
      )
    end
  end
end
