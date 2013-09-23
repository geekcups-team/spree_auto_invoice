Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  namespace :admin do
    match "orders/:order_id/invoices/:id", to: "invoices#show", :via => [:get], :as => :order_invoice
    match "orders/invoices", to: "invoices#download_all", :via => [:get], :as => :dowload_all
    match "orders/:order_id/invoices/:id/send", to: "invoices#send_mail", :via => [:get], :as => :order_send_invoice
    match "orders/:order_id/invoices/:id/generate", to: "invoices#abilitate_invoice", :via => [:get], :as => :order_abilitate_invoice
  end
  
  match "orders/:order_id/invoices/:id", to: "invoices#show", :via => [:get], :as => :order_invoice
  
end
