# frozen_string_literal: true

require_relative "swiss_qr_bill/version"
require_relative "swiss_qr_bill/qr_bill"
require_relative "swiss_qr_bill/qr_bill_parser"

module SwissQRBill
  def self.parse_file(...)
    QRBillParser.parse_file(...)
  end
end
