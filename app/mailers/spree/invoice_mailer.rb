module Spree
  class InvoiceMailer < BaseMailer
    def send_invoice(order, resend = false)
      @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
      subject = (resend ? "[#{Spree.t(:resend).upcase}] " : '')
      subject += "#{Spree::Config[:site_name]} #{Spree.t('invoice_mailer.send_invoice.subject')} ##{@order.number}"
      attachments["#{order.invoice.number}.pdf"] = File.read(@order.invoice.file_path)
      mail(to: @order.email, from: from_address, subject: subject)
    end
  end
end