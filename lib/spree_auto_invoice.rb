require 'spree_core'
require 'spree_auto_invoice/engine'

module SpreeAutoInvoice
  
  ## CONFIGURATION OPTIONS
  mattr_accessor :auto_invoice
  @@auto_invoice = true
  
  mattr_accessor :invoice_template_path
  @@invoice_template_path = "app/views/spree/invoices/invoice_template.html.erb"
  
  mattr_accessor :invoice_path
  @@invoice_path = "invoices"
  
  mattr_accessor :wkhtmltopdf_margin
  @@wkhtmltopdf_margin = {:top    => 10, :bottom => 10, :left   => 15, :right  => 15}
  
  mattr_accessor :invoice_number_generation_method
  @@invoice_number_generation_method = lambda { |next_invoice_number|
        number = "%04d" % next_invoice_number.to_s
        "R-#{Time.now.year}-#{number}"
                                              }
  
  def self.setup
    yield self
  end
  
end