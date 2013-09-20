module Spree
  class InvoicesController < Spree::StoreController
    def show
      order = Spree::Order.find_by(:number => params[:order_id])
      send_file Rails.root.join(SpreeAutoInvoice.invoice_path, "#{order.number}", "#{order.invoice.number}.pdf")
    end
  end
end