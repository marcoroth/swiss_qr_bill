# SwissQRBill

A Ruby Gem for reading and parsing Swiss QR-Bills from documents like PDFs and images.

This gem is meant for reading and parsing Swiss QR-Bill codes out of documents, if you are looking to generate Swiss QR-Bills check out the [`qr-bills` gem](https://github.com/damoiser/qr-bills).

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add swiss_qr_bill
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install swiss_qr_bill
```

Install the required NPM packages:

```bash
yarn add @andreekeberg/imagedata pdf-to-png-converter jsqr
```

## Usage

```ruby
require "swiss_qr_bill"

qr_bills = SwissQRBill.parse_file("path/to/invoice.pdf")

qr_bills.first
# =>
#  #<data SwissQRBill::QRBill
#    header=#<data SwissQRBill::QRBill::Header qr_type="SPC", version="0200", coding_type="1">,
#    creditor_information=#<data SwissQRBill::QRBill::CreditorInformation iban="CH6431961000004421557">,
#    creditor= #<data SwissQRBill::QRBill::StructuredAddress type="S", name="Health insurance fit&kicking", street="Am Wasser", building_number="1", postal_code="3000", town="Bern", country="CH">,
#    ulimate_creditor=#<data SwissQRBill::QRBill::StructuredAddress type="", name="", street="", building_number="", postal_code="", town="", country="">,
#    debtor=#<data SwissQRBill::QRBill::StructuredAddress type="S", name="Sarah Beispiel", street="Mustergasse", building_number="1", postal_code="3600", town="Thun", country="CH">,
#    payment_amount_information=#<data SwissQRBill::QRBill::PaymentAmountInformation amount=111.0, currency="CHF">,
#    payment_reference=#<data SwissQRBill::QRBill::PaymentReference type="QRR", reference="000008207791225857421286694", additional_information="Premium calculation July 2020">,
#    trailer=#<data SwissQRBill::QRBill::Trailer trailer="EPD">,
#    additional_information=#<data SwissQRBill::QRBill::AdditionalInformation billing_information=nil, av1=nil, av2=nil>,
#    raw=[...]
#   >

qr_bills.first.creditor
# =>
#  #<data SwissQRBill::QRBill::StructuredAddress
#    type="S",
#    name="Health insurance fit&kicking",
#    street="Am Wasser",
#    building_number="1",
#    postal_code="3000",
#    town="Bern",
#    country="CH"
#  >

qr_bills.first.to_s
# => "SPC\n0200\n1\nCH6431961000004421557\nS\nHealth insurance fit&kicking\nAm Wasser\n1\n3000\nBern\nCH\n\n\n\n\n\n\n\n111.0\nCHF\nS\nSarah Beispiel\nMustergasse\n1\n3600\nThun\nCH\nQRR\n000008207791225857421286694\nPremium calculation July 2020\nEPD\n\n\n"
```

## Additional Information

#### Specification

* [Swiss Implementation Guidelines for the QR-bill](https://www.six-group.com/dam/download/banking-services/standardization/qr-bill/ig-qr-bill-v2.2-en.pdf)
* [Six Download Center (For sample data, specifications, and more)](https://www.six-group.com/en/products-services/banking-services/payment-standardization/downloads-faq/download-center.html)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/marcoroth/swiss_qr_bill. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/marcoroth/swiss_qr_bill/blob/main/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the SwissQRBill project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/marcoroth/swiss_qr_bill/blob/main/CODE_OF_CONDUCT.md).
