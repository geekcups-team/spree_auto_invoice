Spree::Order.class_eval do
  has_one :invoice, :dependent => :destroy
  after_create :add_invoice

  register_update_hook :update_invoice_state
  
  def update_invoice_state
    if self.invoice_state != 'invoiced'
      if self.paid?
        self.invoice.ready!
        self.update_attribute(:invoice_state, 'ready')
        if (SpreeAutoInvoice.auto_invoice)
          self.invoice.invoice!
          self.update_attribute(:invoice_state, 'invoiced') #TODO Va bene qui aggiornare l'invoice_state? me par ben
        end
      end
    end
  end
  
  def taxes
    result = []
    self.line_items.each do |line_item|
      line_item.taxes.each do |tax|
        if (i = result.index { |r| r[:tax_rate] == tax[:tax_rate] })
          tax_line = result[i]
        else
          tax_line = 
          {
            :tax_rate => tax[:tax_rate],
            :total_tax => 0
          }
          result << tax_line
        end
        tax_line[:total_tax] += tax[:total_tax]
      end
    end
    result
  end
  
  def total_untaxed
    self.line_items.map {|item| item.total_untaxed }.sum
  end
  
  private
    def add_invoice
      self.create_invoice
      self.update_attribute(:invoice_state, 'pending')
    end
  
end
