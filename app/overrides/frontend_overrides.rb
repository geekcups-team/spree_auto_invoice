Deface::Override.new(:virtual_path =>  "spree/orders/show",
                     :insert_top => "#order_summary #order p[data-hook='links']",
                     :name => "invoice_download",
                     :partial => 'spree/shared/invoices/download')