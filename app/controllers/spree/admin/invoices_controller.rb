module Spree
  module Admin
    class InvoicesController < Spree::Admin::BaseController
      def show
        order = Spree::Order.find_by(:number => params[:order_id])
        send_file Rails.root.join(SpreeAutoInvoice.invoice_path, "#{order.number}", "#{order.invoice.number}.pdf")
      end
      
      def send_mail
        order = Spree::Order.find_by(:number => params[:order_id])
        InvoiceMailer.send_invoice(order,true).deliver
        redirect_to edit_admin_order_path(order)
      end
      
      def abilitate_invoice
        order = Spree::Order.find_by(:number => params[:order_id])
        order.invoice.ready
        redirect_to edit_admin_order_path(order)
      end
    end
  end
end
      