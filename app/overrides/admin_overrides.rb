Deface::Override.new(:virtual_path =>  "spree/admin/shared/_content_header",
                     :insert_top => "[data-hook='toolbar'] ul",
                     :name => "admin_orders_index_headers",
                     :partial => 'spree/admin/shared/invoices/download')
# Deface::Override.new(:virtual_path => %q{spree/admin/orders/index},
#                      :insert_before => "[data-hook='admin_orders_index_header_actions']",
#                      :name => "invoice_state_header",
#                      :text => "<th><%= sort_link @search, :invoice_state, I18n.t(:invoice_status, :scope => :spree) %></th>")
                     
# Deface::Override.new(:virtual_path => %q{spree/admin/orders/index},
#                      :insert_before => "[data-hook='admin_orders_index_row_actions']",
#                      :name => "invoice_status_index",
#                      :partial => "spree/admin/shared/invoices/row_cell") 
                     

                     # :partial => "spree/admin/shared/invoices/row_cell") 