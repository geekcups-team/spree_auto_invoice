require 'wicked_pdf'

if defined?(WickedPdf)
  WickedPdf.config = {
    :exe_path => '/usr/local/bin/wkhtmltopdf'
  }
end

WickedPdf.config = {
  :exe_path => SpreeAutoInvoice::WKHTMLToPDF.bin_path
}

SpreeAutoInvoice.setup do |config|

  #Generate automatically invoices. Set false to switch to manually
  config.auto_invoice = true
  
  #Method called to generate the invoice number
  config.invoice_number_generation_method = lambda { |next_invoice_number|
        number = "%04d" % next_invoice_number.to_s
        "R-#{Time.now.year}-#{number}"
  }
  
  #Path to the invoice template
  config.invoice_template_path = "app/views/spree/invoices/invoice_template.html.erb"
  
  #Path for save invoice (relative to Rails.root)
  config.invoice_path = "invoices"
  
  #Margin in the pdf document
  config.wkhtmltopdf_margin = {
    :top    => 20,
    :bottom => 20,
    :left   => 25,
    :right  => 25
  }

end