require 'fileutils'

module Spree
class Invoice < ActiveRecord::Base
    belongs_to :order
    attr_accessible :number, :state, :order
  
    scope :current_year, lambda { where(["created_at > ? AND created_at < ?", Time.now.at_beginning_of_year, Time.now.at_end_of_year]) }
    scope :invoiced, lambda { where(:state => 'invoiced') }
  
    state_machine initial: :pending, use_transactions: false do
      event :ready do
        transition from: :pending, to: :ready, if: lambda { |invoice|
          invoice.determine_state() == 'ready'
        }
      end
      
      event :invoice do
        transition from: :ready, to: :invoiced
      end
      before_transition to: :invoiced, do: :before_invoice
      after_transition to: :invoiced, do: :after_invoice
    end
      
    def determine_state
      order = self.order
      return 'canceled' if order.canceled?
      return 'invoiced' if state == 'invoiced'
      order.paid? ? 'ready' : 'pending'
    end
    
    def before_invoice
      generate_invoice_number
      pdf = generate_pdf
      ensure_invoice_directory
      save_path = Rails.root.join(SpreeAutoInvoice.invoice_path, "#{self.order.number}", "#{self.number}.pdf")
      File.open(save_path, 'wb') do |file|
        file << pdf
      end
    end
    
    def after_invoice
      #TODO Send mail
    end
          
    def generate_pdf
      WickedPdf.new.pdf_from_string(
        StaticRender.render_erb(SpreeAutoInvoice.invoice_template_path, {
          :@order => self.order,
          :@address => self.order.bill_address,
          :@invoice => self
        }), {
          :margin => SpreeAutoInvoice.wkhtmltopdf_margin
        }
      )
    end
    
    private
    
    def generate_invoice_number
      update_attribute(:number, SpreeAutoInvoice.invoice_number_generation_method.call(Spree::Invoice.invoiced.current_year.count + 1))
    end
    
    def ensure_invoice_directory
      order_path = Rails.root.join(SpreeAutoInvoice.invoice_path, "#{self.order.number}")
      FileUtils.mkdir_p(order_path) unless File.directory?(order_path) #TODO si può far meglio? rimuovere il require se si
    end
    
  end
  
  class StaticRender < ActionController::Base
    def self.render_erb(template_path, locals = {})
      view = ActionView::Base.new(ActionController::Base.view_paths, {})
        class << view
        include ApplicationHelper
        include WickedPdfHelper::Assets
        include Spree::BaseHelper
      end
      view.render(:file => template_path, :locals => locals, :layout => nil)
    end
  end
end
