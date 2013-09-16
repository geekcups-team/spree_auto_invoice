require 'spree_auto_invoice'
require 'rails'

module SpreeAutoInvoice
  class Railtie < Rails::Railtie
    rake_tasks do
      require '../tasks/spree_auto_invoice.rake'
    end
  end
end
