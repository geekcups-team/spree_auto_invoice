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
          self.update_attribute(:invoice_state, 'invoiced') #TODO Va bene qui aggiornare l'invoice_state?
        end
      end
    end
  end
  
  
  private
  def add_invoice
    self.create_invoice
    self.update_attribute(:invoice_state, 'pending')
  end
  
end
