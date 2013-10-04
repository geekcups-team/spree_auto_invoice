#require 'zip'
module Spree
  module Admin
    class InvoicesController < Spree::Admin::BaseController
      def show
        order = Spree::Order.find_by(:number => params[:order_id])

        send_file Rails.root.join(order.invoice.file_path) 
      end
      
      def send_mail
        order = Spree::Order.find_by(:number => params[:order_id])
        InvoiceMailer.send_invoice(order,true).deliver
        redirect_to edit_admin_order_path(order)
      end
      
      def create
        order = Spree::Order.find_by(:number => params[:order_id])
        order.invoice.invoice!
        order.update_attribute(:invoice_state, 'invoiced')
        flash[:success] = I18n.t('spree.invoice.success')
        redirect_to edit_admin_order_path(order)
      end
      
      def download_all
        
        params[:q] ||= {}
        params[:q][:completed_at_not_null] ||= '1' if Spree::Config[:show_only_complete_orders_by_default]
        @show_only_completed = params[:q][:completed_at_not_null].present?
        params[:q][:s] ||= @show_only_completed ? 'completed_at desc' : 'created_at desc'

        # As date params are deleted if @show_only_completed, store
        # the original date so we can restore them into the params
        # after the search
        created_at_gt = params[:q][:created_at_gt]
        created_at_lt = params[:q][:created_at_lt]

        params[:q].delete(:inventory_units_shipment_id_null) if params[:q][:inventory_units_shipment_id_null] == "0"

        if !params[:q][:created_at_gt].blank?
          params[:q][:created_at_gt] = Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day rescue ""
        end

        if !params[:q][:created_at_lt].blank?
          params[:q][:created_at_lt] = Time.zone.parse(params[:q][:created_at_lt]).end_of_day rescue ""
        end

        if @show_only_completed
          params[:q][:completed_at_gt] = params[:q].delete(:created_at_gt)
          params[:q][:completed_at_lt] = params[:q].delete(:created_at_lt)
        end

        @search = Order.accessible_by(current_ability, :index).ransack(params[:q])
        @orders = @search.result.includes([:user, :shipments, :payments]).
          page(params[:page]).
          per(params[:per_page] || Spree::Config[:orders_per_page])

        # Restore dates
        params[:q][:created_at_gt] = created_at_gt
        params[:q][:created_at_lt] = created_at_lt
        # like orders
        
        # inizio crezione zip
          file_name = "#{t('spree.invoice.invoices')}.zip"
          t = Tempfile.new("invoice-temp-#{Time.now}")
          Zip::OutputStream.open(t.path) do |z|
            @orders.each do |order|
              if !order.invoice.nil? && !order.invoice.number.nil?
                z.put_next_entry("#{order.invoice.number}.pdf")
                z.print IO.read(order.invoice.file_path)
              end
            end
          end
          send_file t.path, :type => 'application/zip',
                            :disposition => 'attachment',
                            :filename => file_name
          t.close
      end
      
    end
  end
end
      