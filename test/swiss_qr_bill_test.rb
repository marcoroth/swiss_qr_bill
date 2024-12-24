# frozen_string_literal: true

require "test_helper"

class TestSwissQRBill < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::SwissQRBill::VERSION
  end

  def test_parse_qr_bill_from_string
    content = File.read("./test/fixtures/all_fields.txt")

    qr_bill = SwissQRBill::QRBillParser.parse(content)

    assert_equal "SPC", qr_bill.header.qr_type
    assert_equal "0200", qr_bill.header.version
    assert_equal "1", qr_bill.header.coding_type

    assert_equal "CH6431961000004421557", qr_bill.creditor_information.iban

    assert_equal "S", qr_bill.creditor.type
    assert_equal "Health insurance fit&kicking", qr_bill.creditor.name
    assert_equal "Am Wasser", qr_bill.creditor.street
    assert_equal "1", qr_bill.creditor.building_number
    assert_equal "3000", qr_bill.creditor.postal_code
    assert_equal "Bern", qr_bill.creditor.town
    assert_equal "CH", qr_bill.creditor.country

    assert_equal "Am Wasser 1", qr_bill.creditor.line1
    assert_equal "3000 Bern", qr_bill.creditor.line2

    assert_equal "K", qr_bill.ulimate_creditor.type
    assert_equal "Health insurance fit&kicking", qr_bill.ulimate_creditor.name
    assert_equal "Am Wasser 1", qr_bill.ulimate_creditor.line1
    assert_equal "3000 Bern", qr_bill.ulimate_creditor.line2
    assert_equal "CH", qr_bill.ulimate_creditor.country
    assert_equal "Am Wasser 1", qr_bill.ulimate_creditor.street
    assert_equal "Am Wasser 1", qr_bill.ulimate_creditor.building_number
    assert_equal "3000 Bern", qr_bill.ulimate_creditor.postal_code
    assert_equal "3000 Bern", qr_bill.ulimate_creditor.town

    assert_equal 111.0, qr_bill.payment_amount_information.amount
    assert_equal "CHF", qr_bill.payment_amount_information.currency

    assert_equal "S", qr_bill.debtor.type
    assert_equal "Sarah Beispiel", qr_bill.debtor.name
    assert_equal "Mustergasse", qr_bill.debtor.street
    assert_equal "1", qr_bill.debtor.building_number
    assert_equal "3600", qr_bill.debtor.postal_code
    assert_equal "Thun", qr_bill.debtor.town
    assert_equal "CH", qr_bill.debtor.country
    assert_equal "Mustergasse 1", qr_bill.debtor.line1
    assert_equal "3600 Thun", qr_bill.debtor.line2

    assert_equal "000008207791225857421286694", qr_bill.payment_reference.reference
    assert_equal "Premium calculation July 2020", qr_bill.payment_reference.additional_information

    assert_equal "EPD", qr_bill.trailer.trailer

    assert_nil qr_bill.additional_information.billing_information
    assert_nil qr_bill.additional_information.av1
    assert_nil qr_bill.additional_information.av2
  end

  def test_parse_qr_bill_from_file_with_additional_information
    content = File.read("./test/fixtures/all_fields_with_additional_information.txt")

    qr_bill = SwissQRBill::QRBillParser.parse(content)

    assert_equal "//S1/10/10201409/11/200630/20/140.000-53/30/102673831/31/200630", qr_bill.additional_information.billing_information
    assert_equal "eBill/B/sarah.beispiel@einfach-zahlen.ch", qr_bill.additional_information.av1
    assert_nil qr_bill.additional_information.av2
  end

  def test_parsing_qr_code_images_and_pdfs
    tests_mapping = {
      "#{Dir.pwd}/test/fixtures/muster-qr-zahlteile-de/*.jpg" => "#{Dir.pwd}/test/fixtures/datenschema-zu-mustern-txt-dateien-de/*.txt",
      "#{Dir.pwd}/test/fixtures/muster-qr-zahlteile-en/*.jpg" => "#{Dir.pwd}/test/fixtures/datenschema-zu-mustern-txt-dateien-en/*.txt",
      "#{Dir.pwd}/test/fixtures/muster-qr-zahlteile-de/pdf/*.pdf" => "#{Dir.pwd}/test/fixtures/datenschema-zu-mustern-txt-dateien-de/*.txt",
      "#{Dir.pwd}/test/fixtures/muster-qr-zahlteile-en/pdf/*.pdf" => "#{Dir.pwd}/test/fixtures/datenschema-zu-mustern-txt-dateien-en/*.txt"
    }

    tests = tests_mapping.flat_map do |images_path, texts_path|
      images = Dir[images_path]
      texts = Dir[texts_path]

      images.zip(texts)
    end

    tests.each do |image_path, text_path|
      print "."
      result = SwissQRBill::QRBillParser.parse_file(image_path)
      text = SwissQRBill::QRBillParser.parse(File.read(text_path))

      assert_equal text.to_s, result.first.to_s
    end
  end
end
