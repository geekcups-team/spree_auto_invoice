SpreeAutoInvoice
================

Spree invoice gem with state machine.

Dependencies
------------

To generate the pdf is used:[https://code.google.com/p/wkhtmltopdf/](https://code.google.com/p/wkhtmltopdf/)

Installation
------------

Add spree_auto_invoice to your Gemfile:

```ruby
gem 'spree_auto_invoice'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g spree_auto_invoice:install
```

Configuration
-------
In initializers folder you can find spree_auto_invoice.rb with the various configuration

TODO
-------
###General
* What we do when a payment is removed and invoice is generated?
* What we do when a payment is removed and the invoice isn't generated?

###Auto invoice
* Testing auto invoice with immediate payments (credit card)

###Invoice template
* Create better invoice template

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

```shell
bundle
bundle exec rake test_app
bundle exec rspec spec
```

When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'spree_auto_invoice/factories'
```

Copyright (c) 2013 Geekcups srls, released under the New BSD License
